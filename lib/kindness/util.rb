module Kindness
  class << self
    # Englishing home directory.
    def user_home_dir
      Etc.getpwuid.dir
    end

    # Englishing kindness directory.
    def kindness_dir
      "#{user_home_dir}/.kindness"
    end
  end
end
