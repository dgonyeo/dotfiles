#!/usr/bin/env bash
set -e

echo "If your name is not Derek Gonyeo, you probably don't want to run this script."
echo "It messes with more than just my vimrc."
read -p "Are you sure? [y/N] " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

git submodule init
git submodule update
rsync -av .* ~ --exclude=.git --exclude=.gitmodules --exclude=README.md --exclude=install.sh
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*
