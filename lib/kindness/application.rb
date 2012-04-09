module Kindness
  class Application
    include Mixlib::CLI
    
    # Adding sane default installs for any development environment.
    DEFAULT_RECIPES = [
      'dmg', 'homebrew', 'git','lunchy', 
      'virtualbox', 'vagrant', 'veewee'
    ]
    
    # Default aliases for running kindness commands.
    DEFAULT_ALIASES = {
      :change_kindness_site => ['site', 's'],
      :implode_kindness     => ['implode'],
      :update_kindness      => ['update', 'up', 'u']
    }
    
    banner """Example usage:
    kindness update
    kindness implode
    kindness site [url]
    """
    
    option :config_file, 
      :short => "-c CONFIG",
      :long  => "--config CONFIG",
      :default => 'config.rb',
      :description => "The configuration file to use"
    
    option :help,
      :short => "-h",
      :long  => "--help",
      :description => "Show this message",
      :on => :tail,
      :boolean => true,
      :show_options => true,
      :exit => 0
    
    option :version,
      :short => "-v",
      :long  => "--version",
      :description => "Show kindness version",
      :boolean => true,
      :proc => lambda { |v| puts "kindness: #{::Kindness::VERSION}" },
      :exit => 0
    
    # Run kindness... kindly?
    def run
      parse_options
      run_commands
    end
    
    def aliases(cmd)
      DEFAULT_ALIASES.each { |k, v| return k if v.include?(cmd) }
      nil
    end
    
    def run_commands
      if ARGV.size == 0 || aliases(ARGV.first).nil?
        puts self.opt_parser.help
        exit 0
      else
        send(aliases(ARGV.first).to_sym)
      end
    end
    
    # Sets up the default config.rb for chef-solo.
    def check_config_rb
      config_file = "#{Kindness.kindness_dir}/config.rb"
      unless File.exists? config_file
        config_rb = "file_cache_path \"#{Kindness.kindness_dir}/cache\"\n"
        config_rb << "cookbook_path [\n"
        config_rb << "  \"#{Kindness.kindness_dir}/cookbooks\",\n"
        config_rb << "  \"#{Kindness.kindness_dir}/site-cookbooks\"\n"
        config_rb << "]\n"
        File.open(config_file, 'w') { |f| f.write(config_rb) }
      end
    end
    
    # Sets up the default solo.json for chef-solo.
    def check_solo_json
      solo_file = "#{Kindness.kindness_dir}/solo.json"
      unless File.exists? solo_file
        solo_json = "{\n"
        solo_json << "  \"run_list\": [\n"
        DEFAULT_RECIPES.each_with_index do |recipe, i|
          if (DEFAULT_RECIPES.size - 1) == (i)
            solo_json << "    \"recipe[#{recipe}]\"\n"
          else
            solo_json << "    \"recipe[#{recipe}]\",\n"
          end
        end
        solo_json << "  ]\n"
        solo_json << "}\n"
        File.open(solo_file, 'w') { |f| f.write(solo_json) }
      end
    end
    
    # Run the chef-solo application with the config.rb and solo.json.
    def run_chef_solo
      safe_system "chef-solo -c #{Kindness.kindness_dir}/config.rb -j #{Kindness.kindness_dir}/solo.json"
    end
    
    def implode_kindness
      trap("INT") { exit 0 }
      puts  "Are you SURE you want to completely remove kindness?\n"
      puts  "This will recursively remove #{Kindness.kindness_dir} and all associated recipes"
      print "[y/n]: "
      case $stdin.gets.chomp
      when 'Y', 'y'
        FileUtils.rm_rf Kindness.kindness_dir
      end
      exit 0
    end
    
    def update_kindness
      cd Kindness.kindness_dir
      git_init_if_necessary
      safe_system "git pull"
      check_config_rb
      check_solo_json
      run_chef_solo
    end
    
    def change_kindness_site
      git_url = (ARGV.size == 2) ? ARGV.last : nil
      print_site_cookbooks_url_and_exit if git_url.nil?
      cd Kindness.kindness_dir
      setup_site_cookbooks(git_url)
      update_sitecookbooks(git_url)
    end
    
    def print_site_cookbooks_url_and_exit
      if current_sitecookbooks_url.empty?
        puts "No site-cookbooks git repo has been initialized.\n"
        puts "To initialize a site-cookbooks repo type `kindness site [url]`."
      else
        puts current_sitecookbooks_url
      end
      exit 0
    end
    
    def setup_site_cookbooks(url)
      unless File.directory? "site-cookbooks"
        safe_system "git submodule add -f #{url} site-cookbooks"
        safe_system "git submodule init"
        safe_system "git reset HEAD .gitmodules"
        safe_system "git reset HEAD site-cookbooks"
      end
    end
    
    def update_sitecookbooks(url)
      unless url == current_sitecookbooks_url
        safe_system "rm -rf site-cookbooks"
        setup_site_cookbooks(url)
      end
      safe_system "git submodule update"
    end
    
    def current_sitecookbooks_url
      if File.exists?('.gitmodules')
        File.open('.gitmodules').read
            .split("\n").grep(/url/).first.split("=").last.strip
      else
        ''
      end
    end
    
    def git_init_if_necessary
      if Dir['.git/*'].empty?
        safe_system "git init"
        safe_system "git config core.autocrlf false"
        safe_system "git remote add origin #{Kindness.kindness_url}"
        safe_system "git fetch origin"
        safe_system "git reset --hard origin/master"
      end
    rescue Exception
      FileUtils.rm_rf ".git"
      raise
    end
    
    def cd(directory)
      Dir.chdir(directory)
    end
    
    def safe_system(command)
      IO.popen(command) { |f| puts f.gets until f.eof? }
    end
    
  end
end
