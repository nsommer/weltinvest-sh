# weltinvest.sh

`weltinvest.sh` is a one-file shell script that connects to Raisin's WeltInvest and retrieves data of your personal portfolio. Since there are not official APIs available from Raisin, using this script leaves you at your own risk and is only intended for educational purposes.

## Usage

You have to pass your username and password to the script. Please ensure `jq` is installed on your system. This can be done via homebrew or other package managers.

```bash
./weltinvest.sh john.doe@example.org mypassword
```

## License

The code of this script is licensed under the MIT license.
