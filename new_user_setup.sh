#!/usr/bin/env bash
# initial dotfile setup for a new user id
bash -c ./.setup.sh ${1}

chezmoi cd

if [[ -d "${USER}" ]]; then
  echo "${USER} folder already exists, run 'new_machine.sh' instead."
  exit 1
fi

cp -r .defaults/user ./${USER}

cat << EOF > ./${USER}/.chezmoidata/gitconfig.yaml
git_signing_key: $(gpg --show-keys --with-colons temp_public_key.gpg | awk -F: '$1=="fpr"{print $10}')
git_email: $(gpg --with-colons --show-keys public_key.gpg | awk -F: '$1=="uid" {print $10}' | grep -oE '[a-zA-O0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}')
git_username: $(gpg --with-colons --show-keys temp_public_key.gpg | awk -F: '$1=="uid" {print $10}' | sed 's/ (.*)//; s/ <.*>//')
EOF

rm -rf temp_public_key.gpg

# init age
mkdir -p ~/.config/chezmoi/age
age-keygen -o ~/.config/chezmoi/age/keys.txt
age-keygen -y -o ~/.config/chezmoi/age/recipient.txt ~/.config/chezmoi/age/keys.txt

for file in .defaults/files/*; do
    cp -rf ${file} ${HOME}/${file}
    chezmoi add ${HOME}/${file}
done

for file in .defaults/templates/*; do
    cp -rf ${file} ${HOME}/${file}
    chezmoi add --template ${HOME}/${file}
done

chezmoi apply

~/.macos