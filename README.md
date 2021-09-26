# dotfiles

This is my dotfiles' settings.

## How to Install

```console
$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/narugit/dotfiles/master/install.sh)"
```

## Necessary Process in Manual
### ssh 
1. If I does not create `${HOME}/.ssh/id_rsa_personal`, create it.
```console
$ ssh-keygen -t ed25519 -C "narusens@gmail.com" -f ~/.ssh/id_rsa_personal
```

2. Visit [GitHub's SSH key settings page](https://github.com/settings/keys) and register public key.

3. Add key chain.
```console
$ ssh-add -K ~/.ssh/id_rsa_personal
```

## Secret Dotfiles
Secret dotfiles are listed in `.gitignore`.

I suppose that I manage its only in local.

I does not suppose that I upload its to GitHub because its are secret.

### zsh
I can add secret configuration, such as secret environment variable in below.
- `${HOME}/.zshrc.secret`

### git
I can add secret configuration, such as user information (not my private account) in below.

The file overrides other global git configuration.

- `${HOME}/.gitconfig.secret`

### ssh
I can add secret configuration, such as proxy.

- `${HOME}/.ssh/config.secret`

## Test in Docker Container
Note: Not support feature to fetch hourly because I cannot find how to run systemd on Ubuntu 20.04 docker image on macOS. (See [issues#26](https://github.com/narugit/dotfiles/issues/26))

```console
$ cd ${HOME}/dotfiles/test/linux
$ ./dockerrun.sh
```
