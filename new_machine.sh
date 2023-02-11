#!/usr/bin/env bash
# new machine setup of existing user

bash -c ./.setup.sh ${1}

read -r -p "Customize hostname [default: ${HOSTNAME}]?: " hostName

CHEZMOI_HOSTNAME="${hostName:-$HOSTNAME}" \
    CHEZMOI_GIT_SIGNING_KEY="$(gpg --show-keys --with-colons temp_public_key.gpg | awk -F: '$1=="fpr"{print $10}')" \
    CHEZMOI_GIT_EMAIL="$(gpg --with-colons --show-keys public_key.gpg | awk -F: '$1=="uid" {print $10}' | grep -oE '[a-zA-O0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')" \
    CHEZMOI_GIT_USERNAME="$(gpg --with-colons --show-keys temp_public_key.gpg | awk -F: '$1=="uid" {print $10}' | sed 's/ (.*)//; s/ <.*>//')" \
    chezmoi apply

rm -rf temp_public_key.gpg

~/.macos