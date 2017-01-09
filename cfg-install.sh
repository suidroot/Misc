#!/bin/sh

function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}

if [ -f ~/.ssh/id_rsa.pub ];
then
	echo "SSH key exists"
else
	/usr/bin/ssh-keygen
	cat ~/.ssh/id_rsa.pub
	echo "Copy the SSH up to GitHub"
	echo
	echo
	read -n 1 -s -p "Press any key to continue"
fi

git clone --bare git@github.com:suidroot/mydotfile.git $HOME/.cfg

mkdir -p .config-backup
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
config checkout
config config status.showUntrackedFiles no

git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
~/.bash_it/install.sh
