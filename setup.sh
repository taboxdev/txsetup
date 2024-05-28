#!/bin/bash

TXSETUP_ROOT=$(pwd)

# Check if dev directory exists, if not, create it
if [ ! -d "$HOME/dev" ]; then
    mkdir "$HOME/dev" || { echo "Error: Unable to create $HOME/dev"; exit 1; }
    echo "Created $HOME/dev"
fi

# Clone repositories with error checking and progress messages
clone_repo() {
    local repo_name="$1"
    local repo_url="$2"
    local clone_path="$3"

    echo "Cloning $repo_name repository..."

    GIT_SSH_COMMAND="ssh -i $TXSETUP_ROOT/etc/id_rsa_dkey_$repo_name.enc" git clone "$repo_url" "$clone_path" || { echo "Error: Cloning $repo_name repository failed"; exit 1; }

    echo "Cloned $repo_name repository successfully"
}

cd "$HOME/dev" || { echo "Error: Unable to change directory to $HOME/dev"; exit 1; }

clone_repo "txdata" "git@github.com:taboxdev/txdata.git" "./txdata"
clone_repo "txmodels" "git@github.com:taboxdev/txmodels.git" "./txmodels"
clone_repo "fdata" "git@github.com:taboxdev/fdata.git" "../fdata"
clone_repo "tabox" "git@tabox.de:mkatlihan/tabox.git" "./c/tabox/trunk"

cd "$TXSETUP_ROOT" || { echo "Error: Unable to change directory to $TXSETUP_ROOT"; exit 1; }

echo "Script execution completed successfully"