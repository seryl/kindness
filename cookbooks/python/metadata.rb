maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs Python, pip and virtualenv. Includes LWRPs for managing Python packages with `pip` and `virtualenv` isolated Python environments."
version           "1.0.4"

depends           "build-essential"

recipe "python", "Installs python, pip, and virtualenv"
recipe "python::pip", "Installs pip from source."
recipe "python::virtualenv", "Installs virtualenv using the python_pip resource."

%w{ debian ubuntu centos redhat fedora freebsd mac_osx_x }.each do |os|
  supports os
end
