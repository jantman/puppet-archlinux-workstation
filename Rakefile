require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet_blacksmith/rake_tasks' if Bundler.rubygems.find_name('puppet-blacksmith').any?
require 'puppet-strings' if Bundler.rubygems.find_name('puppet-strings').any?
require 'json'

PuppetLint.configuration.fail_on_warnings = true
PuppetLint.configuration.send('relative')

desc 'Generate pooler nodesets'
task :gen_nodeset do
  require 'beaker-hostgenerator'
  require 'securerandom'
  require 'fileutils'

  agent_target = ENV['TEST_TARGET']
  if ! agent_target
    STDERR.puts 'TEST_TARGET environment variable is not set'
    STDERR.puts 'setting to default value of "redhat-64default."'
    agent_target = 'redhat-64default.'
  end

  master_target = ENV['MASTER_TEST_TARGET']
  if ! master_target
    STDERR.puts 'MASTER_TEST_TARGET environment variable is not set'
    STDERR.puts 'setting to default value of "redhat7-64mdcl"'
    master_target = 'redhat7-64mdcl'
  end

  targets = "#{master_target}-#{agent_target}"
  cli = BeakerHostGenerator::CLI.new([targets])
  nodeset_dir = "tmp/nodesets"
  nodeset = "#{nodeset_dir}/#{targets}-#{SecureRandom.uuid}.yaml"
  FileUtils.mkdir_p(nodeset_dir)
  File.open(nodeset, 'w') do |fh|
    fh.print(cli.execute)
  end
  puts nodeset
end

desc "NON-PARALLEL version of release_checks"
task :release_checks_nonparallel do
  Rake::Task[:lint].invoke
  Rake::Task[:validate].invoke
  Rake::Task[:spec].invoke
  Rake::Task["check:symlinks"].invoke
  Rake::Task["check:test_file"].invoke
  Rake::Task["check:dot_underscore"].invoke
  Rake::Task["check:git_ignore"].invoke
end

require 'puppet-strings'

if Bundler.rubygems.find_name('puppet-strings').any?
  # Reimplement puppet-strings "strings:generate" task with custom params
  desc 'Generate Puppet documentation with YARD.'
  task :docs do
    patterns = PuppetStrings::DEFAULT_SEARCH_PATTERNS

    meta = JSON.parse(File.read('metadata.json'))
    options = {
      debug: false,
      backtrace: true,
      markup: 'markdown',
      yard_args: ['--title', "Puppet module jantman/archlinux_workstation #{meta['version']}"],
    }

    PuppetStrings.generate(patterns, options)
  end
end
