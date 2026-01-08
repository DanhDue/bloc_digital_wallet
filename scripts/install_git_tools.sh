#!/bin/bash
set -e

#show git log in the same terminal window.
git config --global --replace-all core.pager "less -F -X"
#setup git editor to the nano.
git config --global core.editor "nano"

GREEN_BOLD="\033[1;32m"
RESET_FORMATING="\033[0m"

mkdir -p ~/tools/git-scripts
sudo chmod +x ~/tools/git-scripts
cp ./scripts/githooks/* .git/hooks
sudo chmod +x .git/hooks

echo -e "\033[7;32m                                       \033[0m"
echo -e "\033[7;32m git hooks are installed!!!            \033[0m"
echo -e "\033[7;32m                                       \033[0m"