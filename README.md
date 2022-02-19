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

3. (Only in Darwin) Add key chain.
```console
$ ssh-add -K ~/.ssh/id_rsa_personal
```

### Keyboard shortcut
- Disable default keyboard shortcut, <kbd>Ctrl-Space</kbd> not to conflict with [my tmux prefix](https://github.com/narugit/dotfiles/blob/dddb2c128df8fb8ef2ed2b87fbf5d5daf21b789c/etc/tmux/.tmux.d/keybinding.tmux#L1).

<details>
<summary>...</summary>
<img src="https://user-images.githubusercontent.com/28133383/154788477-01ea7358-6eae-45d8-b174-f89fdbc4d403.png" width="50%">
</details>


## Features
### Monitoring Differences Between Remote and Local Dotfiles
When opening zsh, if there is a defference between remote and local dotfiles, warning message appears.

![monitor-dotfiles](https://user-images.githubusercontent.com/51317139/134848314-2051a95a-15ae-4f40-bbeb-d4188c85ef3f.png)

### Secret Dotfiles
Secret dotfiles are listed in `.gitignore`.

I suppose that I manage its only in local.

I does not suppose that I upload its to GitHub because its are secret.

#### zsh
I can add secret configuration, such as secret environment variable in below.
- `${HOME}/.zshrc.secret`

#### git
I can add secret configuration, such as user information (not my private account) in below.

The file overrides other global git configuration.

- `${HOME}/.gitconfig.secret`

#### ssh
I can add secret configuration, such as proxy.

- `${HOME}/.ssh/config.secret`

## Test in Docker Container
Note: Not support feature to fetch preodically because I cannot find how to run systemd on Ubuntu 20.04 docker image on macOS. (See [issues#26](https://github.com/narugit/dotfiles/issues/26))

```console
$ ${HOME}/dotfiles/test/linux/dockerrun.sh
```

