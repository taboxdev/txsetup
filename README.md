# TXSetup

## Overview

TXSetup is a project designed to simplify the setup process of TABOX SDK by securely managing deploy keys and automating the repository-cloning. 

If you are a qualified tester/developer, an `api_token` to decrypt (encrypted) deploy keys will be required.  You should have received this token via email. 

If you are an admin, make sure to setup your `~/.ssh` folder and `~/.ssh/config` file to give you access to the private repositories. You should already have your ssh keys incorporated with this repository and obtained the `api_token` from the master database. 

See `Step 1` in [Setup Instructions](#setup-instructions) section on `api_token`. 

## Remark
It is customary for admins to make the initial clone with 

```bash
git clone git@github.com-to-taboxdev:taboxdev/txsetup.git
```

This requires an associated configuration entry in `~/.ssh/config`.

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

- **OpenSSL-3**: Required for encryption and decryption of deploy keys.
- **Git**: For cloning repositories.
- **SSH**: To manage SSH keys and clone repositories.

### Windows
- **Git-for-Windows** [Git-2.45.1-64-bit.exe](https://github.com/git-for-windows/git/releases/download/v2.45.1.windows.1/Git-2.45.1-64-bit.exe). This shell environment includes OpenSSL, Git and SSH.
- For other `Git-for-Windows` versions, visit [https://gitforwindows.org](https://gitforwindows.org)

### Optional
- **LINDO API**: For optimization features. This requires a license from [LINDO Systems, Inc](https://www.lindo.com).

## Setup Instructions

- Step 1: Edit `etc/.bottles` and update the `api_token` entry with the token provided to you via email or the master database.

- Step 2: Execute the setup script to set up TABOX SDK environment on your computer.
	
	Testers/Developers:

   ```bash
   ./setup.sh
   ```
   
	Admins:

   ```bash
   ./admin_setup.sh
   ```
   
## Contributing

If you find any issues or have suggestions for improvements, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License.