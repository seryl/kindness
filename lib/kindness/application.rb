module Kindness
  class Application
    include Mixlib::CLI
    
    DEFAULT_RECIPES = [
      'virtualbox', 'vagrant', 'veewee',
      'pip', 'virtualenv', 'virtualenvwrapper' ]
    
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
      proc: lambda { |imp| puts imp },
      exit: 0
    
    option :version,
      short: "-v",
      long:  "--version",
      description: "Show kindness version",
      boolean: true,
      proc: lambda { |v| puts "kindness: #{::Kindness::VERSION}" },
      exit: 0
    
    def run
      check_platform
      check_config_rb
      check_solo_json
    end
    
    def user_home_dir
      Etc.getpwuid.dir
    end
    
    def kindness_dir
      "#{user_home_dir}/.kindness"
    end
    
    def check_platform
      if RUBY_PLATFORM =~ /darwin/
        DEFAULT_RECIPES << "lunchy"
      end
    end
    
    def check_config_rb
      config_file = "#{kindness_dir}/config.rb"
      if !File.exists? config_file
        config_rb = "file_cache_path \"#{kindness_dir}/cache\"\n"
        config_rb << "cookbook_path [\"#{kindness_dir}/cookbooks\","
        config_rb << "\"#{kindness_dir}/site-cookbooks\"]\n"
        File.open(config_file, 'w') { |f|
          f.write(config_rb) }
      end
    end
    
    def check_solo_json
      solo_file = "#{kindness_dir}/solo.json"
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
