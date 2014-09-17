#!/bin/bash

set -e

SRC_DIRECTORY="$HOME/src"
SITES_DIRECTORY="$HOME/Sites"
INSTALL_DIRECTORY="$SRC_DIRECTORY/base_osx"

# Download and install Command Line Tools
if [[ ! -x /usr/bin/gcc ]]; then
    echo "Info   | Install   | xcode"
    xcode-select --install
fi

# Download and install Homebrew
if [[ ! -x /usr/local/bin/brew ]]; then
    echo "Info   | Install   | homebrew"
    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
fi


# Modify the PATH
export PATH=/usr/local/bin:$PATH


# Download and install python
if [[ ! -x /usr/local/bin/python ]]; then
    echo "Info   | Install   | python"
    brew install python --framework --with-brewed-openssl
fi

# Download and install Ansible
if [[ ! -x /usr/local/bin/ansible ]]; then
    brew install ansible
fi

# Download and install git
if [[ ! -x /usr/local/bin/git ]]; then
    echo "Info   | Install   | git"
    brew install git
fi

# Make the code directory
mkdir -p $SITES_DIRECTORY
mkdir -p $SRC_DIRECTORY
mkdir -p $INSTALL_DIRECTORY

# Clone down ansible
if [[ ! -f $INSTALL_DIRECTORY/site.yml ]]; then
    git clone https://github.com/aryrabelo/ansible-base-osx.git $INSTALL_DIRECTORY
    
else
    cd $INSTALL_DIRECTORY
    git pull origin master
fi

#Install RVM
if [[ ! -d ~/.rvm ]]; then
    \curl -sSL https://get.rvm.io | bash -s stable
    source ~/.rvm/scripts/rvm
fi    

# Create Sites Dir
if [[ ! -d ~/Sites ]]; then
    mkdir ~/Sites
fi  
    

# Provision the box
ansible-playbook --ask-sudo-pass -i $INSTALL_DIRECTORY/inventory $INSTALL_DIRECTORY/site.yml --connection=local
