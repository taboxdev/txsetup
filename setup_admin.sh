#!/bin/bash
UNAME=$(uname)
TXSETUP_ROOT=$(pwd)
if [ ! -d "$TXSETUP_ROOT/etc" ]; then
    echo "Error: $TXSETUP_ROOT/etc not found."
    echo "Make sure you are running this script from inside ./txsetup folder"
    exit 1
fi

source $TXSETUP_ROOT/etc/txgetopt.sh

# Check if dev directory exists, if not, create it
if [ ! -d "$HOME/dev" ]; then
    mkdir "$HOME/dev" || { echo "Error: Unable to create $HOME/dev"; exit 1; }
    echo "Created $HOME/dev"
fi

# Function to extract value from JSON
# Usage: extract_value <json_string> <key>
extract_value() {
    local json="$1"
    local key="$2"

    # Use grep to find the line containing the key and value
    # Then use sed to extract the value
    local value=$(echo "$json" | grep -o "\"$key\":\s*\"[^\"]*\"" | sed 's/.*: "\(.*\)"/\1/')

    echo "$value"
}

files=(
    etc/repo_config.enc
)

for file in "${files[@]}"; do
	./txdecfile.sh "$file"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to decrypt $file"
        exit 1
    fi
done


# Check if etc/repo_config.dec exists
if [ ! -f "$TXSETUP_ROOT/etc/repo_config.dec" ]; then
    echo "Error: $TXSETUP_ROOT/etc/repo_config.dec file not found."
    exit 1
fi

# Read JSON from etc/repo_config.dec file
json=$(<"$TXSETUP_ROOT/etc/repo_config.dec" tr -d '\r\n')

cd "$HOME/dev" || { echo "Error: Unable to change directory to $HOME/dev"; exit 1; }

# Loop through each JSON object
while IFS= read -r line; do
    # Extract values from current JSON object
    repo_name=$(extract_value "$line" "name")
    repo_url=$(extract_value "$line" "url")
    clone_path=$(extract_value "$line" "path")
    port=$(extract_value "$line" "port")

    # Check if any value is missing
    if [[ -z $repo_name || -z $repo_url || -z $clone_path || -z $port ]]; then
        echo "Error: Missing key or value in JSON record."
        continue
    fi
	
	if [ ! -d $clone_path ]; then
		# Check if forced run or dry run
		if [ -n "${force+x}" ]; then
			# Perform the action
			echo "Cloning repository: $repo_name"
			if ! GIT_SSH_COMMAND="ssh  -p $port" git clone "$repo_url" "$clone_path"; then
				echo "Error: Cloning $repo_name repository failed"
				exit 1
			fi
		else
			# Echo the command for dry run
			echo "GIT_SSH_COMMAND=\"ssh  -p $port\" git clone \"$repo_url\" \"$clone_path\" (dry-run, -force to force)"
		fi
	else
		echo "Warning: $clone_path already exists, skipping cloning.."
		echo "GIT_SSH_COMMAND=\"ssh  -p $port\" git clone \"$repo_url\" \"$clone_path\" (dry-run, -force to force)"
	fi
done <<< "$(echo "$json" | grep -o '{[^}]*}')"

cd "$TXSETUP_ROOT" || { echo "Error: Unable to change directory to $TXSETUP_ROOT"; exit 1; }

echo "Script execution completed successfully"

UNAME=$(uname)
cd ..
if [ ! -d lindoapi ]; then
	if [ "${UNAME:0:6}" = "CYGWIN" -o "${UNAME:0:7}" = "MINGW64" ]; then
		LINDO_URL=https://www.lindo.com/downloads/LAPI-WINDOWS-64x86-15.0.tar.gz
	elif [ "${UNAME}" = "Linux" ]; then
		LINDO_URL=https://www.lindo.com/downloads/LAPI-LINUX-64x86-15.0.tar.gz
	elif [ "${UNAME}" = "Darwin" ]; then
		LINDO_URL=https://www.lindo.com/downloads/LAPI-OSX-64x86-15.0.tar.gz
	fi
	if [ ! -z "$LINDO_URL" ]; then
		curl -A "Mozilla/5.0" -O "$LINDO_URL"
		filename=${LINDO_URL##*/}
		tar zxvf $filename
	fi
else
	echo "$(pwd)/lindoapi exists.."
fi
cd $TXSETUP_ROOT

# Define a unique marker to check if the aliases have already been added
MARKER="# Added by setup.sh for tabox aliases"

# Check if the marker already exists in .bashrc
if ! grep -qF "$MARKER" ~/.bashrc; then
    # If .bashrc exists, append the aliases with the marker
    if [ -f ~/.bashrc ]; then
        echo -e "\n$MARKER" >> ~/.bashrc
        cat $HOME/dev/c/tabox/trunk/bin/txalias.sh >> ~/.bashrc
    else
        # If .bashrc does not exist, create it and add the aliases with the marker
        echo "$MARKER" > ~/.bashrc
        cat $HOME/dev/c/tabox/trunk/bin/txalias.sh >> ~/.bashrc
    fi
else
    echo "Aliases already added to .bashrc"
fi

