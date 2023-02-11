#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: ${0} <git remote>"
  exit 1
fi

GIT_REMOTE="${1}"

if type brew >/dev/null 2>&1; then
    brew update
    brew upgrade
else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# install chezmoi, age, gpg and gh
brew install age chezmoi gnupg gh

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# get bash binary path
BASH_PATH=$(which bash)

if [[ "${BASH_PATH}" != "${BREW_PREFIX}/bin/bash " ]]; then
  brew install bash bash-completion2
  if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
    echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
    chsh -s "${BREW_PREFIX}/bin/bash";
  fi

  if ! fgrep -q "${BREW_PREFIX}/bin/brew shellenv bash" ${HOME}/.bash_profile; then
    # eval in current shell
    eval "$(${BREW_PREFIX}/bin/brew shellenv bash)"
  fi
fi

# init chezmoi
chezmoi init ${GIT_REMOTE}

# generate gpg key for signing
read -r -p "Enter gpg key user <first> <last> name: " keyUser
read -r -p "Enter gpg key email: " keyEmail
read -r -p "Enter gpg key github title: " ghKeyName
gpg --batch --passphrase '' --quick-gen-key "${keyUser} <${keyEmail}>" rsa4096 default 
gpg --armor --export "${keyEmail}" > temp_public_key.gpg

# add to github
gh auth login -s write:gpg_key
gh gpg-key add temp_public_key.gpg --title "${ghKeyName}"

