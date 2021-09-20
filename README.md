# dotfiles

This is my dotfiles' settings.

## How to Install

```console
$ bash -c "$(curl -fsSL https://raw.githubusercontent.com/narugit/dotfiles/master/install.sh)"
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

