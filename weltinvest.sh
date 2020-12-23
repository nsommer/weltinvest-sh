#!/usr/bin/env sh

#
# Command Line Argument Processing
#

if [ "$#" -ne 2 ]; then
  echo "Usage: ./weltinvest.sh email password"
  exit
fi

RAISIN_USERNAME=$1
RAISIN_PASSWORD=$2

which jq > /dev/null
if [ $? -ne 0 ]; then
	echo "Please install jq (json processor), for example through homebrew."
	exit
fi

#
# Login - Get Session Cookie
#

SESSION_COOKIE_FILENAME="/tmp/weltinvest_sh_session_cookies.txt"
touch $SESSION_COOKIE_FILENAME

LOGIN_RESPONSE=$(
	curl \
		https://banking.weltsparen.de/savingglobal/rest/open_api/v2/login \
		--request POST \
		--header 'Content-Type: application/json' \
		--header 'Accept: application/json' \
		--data "{ \"username\": \"$RAISIN_USERNAME\", \"password\": \"$RAISIN_PASSWORD\" }" \
		--cookie-jar $SESSION_COOKIE_FILENAME \
		--silent
)

DIPLAY_NAME=$(echo $LOGIN_RESPONSE | jq -r '.customer.display_name')

#
# Get current Balance
#

INVESTMENT_RESPONSE=$(
	curl \
		https://banking.weltsparen.de/savingglobal/rest/open_api/v2/cockpit/investment \
		--header 'Accept: application/json' \
		--cookie $SESSION_COOKIE_FILENAME \
		--silent
)
	
ASSET_BALANCE_AMOUNT=$(echo $INVESTMENT_RESPONSE | jq -r '.asset_balance.value')
PORTFOLIO_NAME=$(echo $INVESTMENT_RESPONSE | jq -r '.portfolio_name')

#
# Print data
#

echo "$PORTFOLIO_NAME: $ASSET_BALANCE_AMOUNT"
	
#
# Logout and Cleanup
#

curl \
	https://banking.weltsparen.de/savingglobal/rest/open_api/v2/logout \
	--request POST \
	--cookie $SESSION_COOKIE_FILENAME \
	--silent

rm $SESSION_COOKIE_FILENAME