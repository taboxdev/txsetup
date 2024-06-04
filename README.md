# TXSetup

## Overview

TXSetup is a project designed to simplify the setup process of TABOX SDK by securely managing deploy keys and automating the repository-cloning. You will need an `api_token` to decrypt the encrypted deploy keys. If you are a qualified tester/developer, you should have received this token via email. See `Step 1` in [Setup Instructions](#setup-instructions) section.

## File Structure

	txsetup/
	+-- README.md
	+-- etc/
	   +-- .bottles.template
	   +-- repo_config.enc
	   +-- id_rsa_dkey_fdata.enc
	   +-- id_rsa_dkey_txsetup.enc
	   +-- id_rsa_dkey_txdata.enc
	   +-- id_rsa_dkey_txmodels.enc
	+-- txdecfile.sh
	+-- txencfile.sh
	+-- setup.sh


- **etc/**: Contains list of private repositories and their deploy keys (encrypted).
- **txdecfile.sh**: Script to decrypt files.
- **txencfile.sh**: Script to encrypt files.
- **setup.sh**: Script to automate the setup process.

## Prerequisites

### Linux/MacOS

- **OpenSSL**: Required for encryption and decryption of deploy keys.
- **Git**: For cloning repositories.
- **SSH**: To manage SSH keys and clone repositories.

### Windows
- **Git-for-Windows** [Git-2.45.1-64-bit.exe](https://github.com/git-for-windows/git/releases/download/v2.45.1.windows.1/Git-2.45.1-64-bit.exe)
- For other `Git-for-Windows` versions, visit [https://gitforwindows.org](https://gitforwindows.org)

### Optional
- **LINDO API**: For optimization features. This requires a license from [LINDO Systems, Inc](https://www.lindo.com).

## Setup Instructions

- Step 1: Edit `etc/.bottles` and update the `api_token` entry with the token provided to you via email.

- Step 2: Run the `setup.sh` script to set up TABOX SDK environment on your computer.  Execute the setup script:

   ```bash
   ./setup.sh
   ```
   
## Contributing

If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.