module Kindness
  class Application
    include Mixlib::CLI
    
    # Adding sane default installs for any development environment.
    DEFAULT_RECIPES = [ 'virtualbox', 'vagrant', 'veewee' ]
    
    banner "usage: kindness (options)"
    
    option :help,
      short: "-h",
      long:  "--help",
      description: "Show this message",
      on: :tail,
      boolean: true,
      show_options: true,
      exit: 0
    
    option :implode,
      short: "-i",
      long:  "--implode",
      description: "Removes the kindness installation completely.",
      boolean: true,
      proc: lambda { |imp|
        puts "Are you SURE you want to completely remove kindness?"
        print "This will recursively remove #{Kindness.kindness_dir} [y/n]: "
        case gets.strip
        when 'Y', 'y'
          FileUtils.rm_rf Kindness.kindness_dir
        end
      },
      exit: 0
    
    option :version,
      short: "-v",
      long:  "--version",
      description: "Show kindness version",
      boolean: true,
      proc: lambda { |v| puts "kindness: #{::Kindness::VERSION}" },
      exit: 0
    
    # Run kindness... kindly?
    def run
      parse_options
      check_platform
      check_config_rb
      check_solo_json
    end
    
    # Adds lunchy to the default recipes if the operating system is OSX.
    def check_platform
      if RUBY_PLATFORM =~ /darwin/
        DEFAULT_RECIPES << "lunchy"
      end
    end
    
    # Sets up the default config.rb for chef-solo.
    def check_config_rb
      config_file = "#{Kindness.kindness_dir}/config.rb"
      if !File.exists? config_file
        config_rb = "file_cache_path \"#{Kindness.kindness_dir}/cache\"\n"
        config_rb << "cookbook_path [\"#{Kindness.kindness_dir}/cookbooks\","
        config_rb << "\"#{Kindness.kindness_dir}/site-cookbooks\"]\n"
        File.open(config_file, 'w') { |f|
          f.write(config_rb) }
      end
    end
    
    # Sets up the default solo.json for chef-solo.
    def check_solo_json
      solo_file = "#{Kindness.kindness_dir}/solo.json"
      if !File.exists? solo_file
        solo_json = "{\n"
        solo_json << "  \"run_list\": [\n"
        DEFAULT_RECIPES.each { |recipe|
          solo_json << "    \"recipe[#{recipe}]\",\n"
        }
        solo_json << "  ]\n"
        solo_json << "}\n"
        File.open(solo_file, 'w') { |f|
          f.write(solo_json) }
      end
    end
    
  end
end
