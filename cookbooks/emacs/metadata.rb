maintainer       "Josh Toft"
maintainer_email "joshtoft@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures emacs"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

supports         "mac_osx_x"

%w( homebrew ).each do |cp|
  depends cp
end
