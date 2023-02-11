# dotfiles
Dev dotfiles with [chezmoi](https://www.chezmoi.io)

## Setup 

### For a new user (uid)

Run `./new_user_setup.sh`

### For an existing user on a new machine

Transfer `age` key file and recepients file to new machine's `~/.config/chezmoi/age/keys.txt` and `~/.config/chezmoi/age/recipient.txt` 

Run `./new_machine.sh`

## Day-to-day

### Editing 

Edit a dotfile with `chezmoi edit`. It will be automatically encrypted and pushed to `https://github.com/<github-id>/dotfiles/$USER`

For example: `chezmoi add ~/.bash_profile`

Then "apply" changes with `chezmoi apply`

### Packages

Edit homebrew / mise / curl - installed packages in `chezmoi` source state:

```
chezmoi cd
vi ${USER}/.chezmoidata/packages.yaml
chezmoi apply
```
