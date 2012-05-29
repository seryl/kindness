#
# Author:: Josh Toft <joshtoft@gmail.com>
# Cookbook Name:: postgresql
# Recipe:: default
#
# Copyright 2012, Josh Toft
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
include_recipe "homebrew"

package "postgresql"

bash "initialize postgresql database" do
  code <<-EOH
  if [ ! -f /usr/local/var/postgres/PG_VERSION ]; then
    initdb /usr/local/var/postgres
  fi
  
  BREW_PG_DIR=`brew info postgres | grep '/usr/local/Cellar/postgresql/' | head -n 1 | awk '{print $1}'`
  BREW_PG_DIR=$BREW_PG_DIR/bin
  LION_PG_DIR=`which postgres | xargs dirname`
  LION_PSQL_DIR=`which psql | xargs dirname`
  
  PG_LATEST=`echo $BREW_PG_DIR | awk 'BEGIN { FS = "\/" } ; { print $6 }'`
  PG_CUR=`postgres --version | awk '{ print $3 }'`
  
  if [ $PG_CUR != $PG_LATEST ]; then
    sudo mkdir -p $LION_PG_DIR/archive
    sudo mkdir -p $LION_PSQL_DIR/archive
    
    for i in `ls $BREW_POSTGRES_DIR`
    do
      if [ -f $LION_PG_DIR/$i ]; then
        sudo mv $LION_PG_DIR/$i $LION_PG_DIR/archive/$i
        sudo ln -s $BREW_PG_DIR/$i $LION_PG_DIR/$i
      fi
      
      if [ -f $LION_PSQL_DIR/$i ]; then
        sudo mv $LION_PSQL_DIR/$i $LION_PSQL_DIR/archive/$i
        sudo ln -s $BREW_PG_DIR/$i $LION_PSQL_DIR/$i
      fi
    done
  fi
  EOH
end
