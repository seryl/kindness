name             "homebrew"
maintainer       "Josh Toft"
maintainer_email "joshtoft@gmail.com"
license          "Apache 2.0"
description      "Install Homebrew and use it as your package provider in Mac OS X"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "1.0.1"
recipe           "homebrew", "Install Homebrew"
supports         "mac_os_x"
