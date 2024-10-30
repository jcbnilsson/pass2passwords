#!/bin/sh
# pass2passwords.sh
# Licensed under the GNU General Public License version 3.
# Copyright(c) 2024 Jacob Nilsson
# https://jacobnilsson.com

printf "%s\n" "Title,URL,Username,Password,Notes,OTPAuth" > pass2passwords_output.csv || exit 1

for it in $(ls "${PASSWORD_STORE_DIR:-$HOME/.password-store}" | sed "s/[.]gpg//g" | grep -v "\-id" | grep -v "\-otp" | grep -v "\-username"); do
    title="$it"
    username=""
    password="$(pass "$it")"
    otp_auth=""
    url=""
    notes=""
    printf "Exporting '%s'\n" "$it"

    if [ -e "${PASSWORD_STORE_DIR:-$HOME/.password-store}/${it}-username.gpg" ]; then
        username="$(pass "${it}-username")"
    fi
    if [ -e "${PASSWORD_STORE_DIR:-$HOME/.password-store}/${it}-otp.gpg" ]; then
        otp_auth="$(pass "${it}-otp")"
    fi

    printf "%s," "${title}" >> pass2passwords_output.csv
    printf "%s," "${url}" >> pass2passwords_output.csv
    printf "%s," "${username}" >> pass2passwords_output.csv
    printf "%s," "${password}" >> pass2passwords_output.csv
    printf "%s," "${notes}" >> pass2passwords_output.csv
    printf "%s\n" "${otp_auth}" >> pass2passwords_output.csv
done
