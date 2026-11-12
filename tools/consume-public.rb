require 'fileutils'
require 'tmpdir'
require 'json'
require 'xcodeproj'

version = '0.1.0-preview.7.0'
work = Dir.mktmpdir('weapp-public-pods-', ENV.fetch('RUNNER_TEMP', Dir.tmpdir))
ENV['CP_HOME_DIR'] = File.join(work, 'pod-home')
ENV['CP_CACHE_DIR'] = File.join(work, 'pod-cache')
ENV['GIT_CONFIG_COUNT'] = '2'
ENV['GIT_CONFIG_KEY_0'] = 'credential.helper'
ENV['GIT_CONFIG_VALUE_0'] = ''
ENV['GIT_CONFIG_KEY_1'] = 'http.extraHeader'
ENV['GIT_CONFIG_VALUE_1'] = ''
ENV['GIT_TERMINAL_PROMPT'] = '0'
report = { version: version, authentication: 'none', status: 'running', work: work, checks: [] }
receipt = File.expand_path('../artifacts/public-pods-consumer.json', __dir__)
FileUtils.mkdir_p(File.dirname(receipt))
begin
  Dir.chdir(work) do
    File.write('AppDelegate.swift', <<~SWIFT)
      import UIKit
      import WeappContainer
      @main final class AppDelegate: UIResponder, UIApplicationDelegate {
        var window: UIWindow?
        var session: WeappContainerSession?
        func application(_ application: UIApplication, didFinishLaunchingWithOptions options: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
          session = WeappContainerSession(configuration: .init(storageKey: "public-pod-consumer"))
          return true
        }
      }
    SWIFT
    File.write('desktop.mm', <<~CPP)
      #include <weapp/desktop.h>
      int main() {
        auto value = weapp_desktop_value_object();
        if (!value) return 1;
        weapp_desktop_value_destroy(value);
        return 0;
      }
    CPP
    project = Xcodeproj::Project.new('PublicPods.xcodeproj')
    [['PublicIOS', :application, :ios, '16.0', 'AppDelegate.swift'],
     ['PublicMacOS', :command_line_tool, :osx, '12.0', 'desktop.mm']].each do |name, type, platform, minimum, source|
      target = project.new_target(type, name, platform, minimum)
      target.source_build_phase.add_file_reference(project.main_group.new_file(source))
      target.build_configurations.each do |config|
        config.build_settings.merge!('PRODUCT_BUNDLE_IDENTIFIER' => "dev.weapp.#{name}",
          'SWIFT_VERSION' => '5.9', 'GENERATE_INFOPLIST_FILE' => 'YES', 'CODE_SIGNING_ALLOWED' => 'NO',
          'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17')
        if platform == :osx
          config.build_settings['HEADER_SEARCH_PATHS'] = '$(inherited) "$(PODS_ROOT)/WeappContainerDesktop/include"'
        end
      end
    end
    project.save
    File.write('Podfile', <<~PODFILE)
      source 'https://github.com/weapp-container/Specs.git'
      project 'PublicPods.xcodeproj'
      target 'PublicIOS' do
        platform :ios, '16.0'
        use_frameworks! :linkage => :static
        pod 'WeappContainer', '#{version}'
      end
      target 'PublicMacOS' do
        platform :osx, '12.0'
        pod 'WeappContainerDesktop', '#{version}'
      end
    PODFILE
    commands = [
      ['resolve-public-specs', ['pod', 'install', '--verbose']],
      ['ios-simulator-build', ['xcodebuild', '-workspace', 'PublicPods.xcworkspace', '-scheme', 'PublicIOS', '-destination', 'generic/platform=iOS Simulator', '-derivedDataPath', 'build-ios', 'CODE_SIGNING_ALLOWED=NO']],
      ['macos-build', ['xcodebuild', '-workspace', 'PublicPods.xcworkspace', '-scheme', 'PublicMacOS', '-destination', 'platform=macOS', '-derivedDataPath', 'build-macos', 'CODE_SIGNING_ALLOWED=NO']],
      ['macos-execute', [File.join(work, 'build-macos/Build/Products/Debug/PublicMacOS')]]
    ]
    commands.each do |label, command|
      log = File.join(File.dirname(receipt), "#{label}.log")
      passed = system(*command, out: log, err: [:child, :out])
      report[:checks] << { label: label, status: passed ? 'passed' : 'failed', log: File.basename(log) }
      raise "#{label} failed; see #{log}" unless passed
    end
    lock = File.read('Podfile.lock')
    raise 'Public Specs resolution is missing' unless lock.include?('https://github.com/weapp-container/Specs.git:')
    ['WeappContainer', 'WeappContainerDesktop'].each do |name|
      raise "Wrong version resolved for #{name}" unless lock.include?("#{name} (#{version})")
    end
    FileUtils.cp('Podfile.lock', File.join(File.dirname(receipt), 'Podfile.lock'))
    report[:status] = 'passed'
  end
rescue => error
  report[:status] = 'failed'
  report[:error] = error.message
ensure
  File.write(receipt, JSON.pretty_generate(report) + "\n")
  puts JSON.pretty_generate(report)
end
exit(report[:status] == 'passed' ? 0 : 1)
