# Dotfiles

This repo contains my Linux dotfiles.

## Overview

- Symlinks managed using [Stow](https://www.gnu.org/software/stow/manual/stow.html)

## Machine-local config (secrets, work-only settings)

`zshrc/.zshrc` ends with:

```zsh
[[ ! -f ~/.zshrc.local ]] || source ~/.zshrc.local
```

`~/.zshrc.local` is **not** in this repo and is not stowed — create it by hand on each
machine. Anything that must not be committed goes there: API tokens, employer-specific
setup, per-host paths. Because it is sourced last, it can also override anything above it.

Set it up with `chmod 600 ~/.zshrc.local` since it holds credentials.

## Requirements

- Neovim v0.10.1

## TODO

- Continue configuring neovim
- (Maybe) Install a better terminal emulator
- Automate installation of process of everything

## Resources Used:

- https://www.jakewiesler.com/blog/managing-dotfiles
- [Oh my zsh](https://github.com/ohmyzsh/ohmyzsh)
- [Neovim Config](https://www.youtube.com/watch?v=w7i4amO_zaE)

## Note to Self

Install: node/nvm, go, ripgrep
