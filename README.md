# TXSetup

## Overview

TXSetup is a project designed to simplify the setup process by securely managing deploy keys and automating the repository cloning process of TABOX environment. This repository includes scripts to encrypt and decrypt deploy keys, as well as a setup script to automate the configuration.

## File Structure

	txsetup/
	+-- .git/
	+-- .gitignore
	+-- README.md
	+-- etc/
	¦ +-- .bottles.template
	¦ +-- id_ed25519_dkey_fdata.enc
	¦ +-- id_ed25519_dkey_txsetup.enc
	¦ +-- id_rsa_dkey_txdata.enc
	+-- txdecfile.sh
	+-- txencfile.sh


- **etc/**: Contains encrypted deploy keys for private repositories.
- **txdecfile.sh**: Script to decrypt files.
- **txencfile.sh**: Script to encrypt files.
- **setup.sh**: Script to automate the setup process.

## Prerequisites

- **OpenSSL**: Required for encryption and decryption of deploy keys.
- **Git**: For cloning repositories.
- **SSH**: To manage SSH keys and clone repositories.

## Setup Instructions

### Step 1: Edit `etc/.bottles` and update the `api_token` entry with the token provided to you via email

### Step 2: The `setup.sh` script automates set up TABOX environment on your computer.  Execute the setup script:

   ```bash
   ./setup.sh
   ```
   
## Contributing

If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.