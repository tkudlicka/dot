# tku dot files

## Usage

### Install

This playbook includes a custom shell script located at `bin/dotfiles`. This script is added to your $PATH after installation and can be run multiple times while making sure any Ansible dependencies are installed and updated.

This shell script is also used to initialize your environment after installing `Darwin` and performing a full system upgrade as mentioned above.

> NOTE: You must follow required steps before running this command or things may become unusable until fixed.

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tkudlicka/dot/main/bin/dotfiles)"
```

If you want to run only a specific role, you can specify the following bash command:
```bash
curl -fsSL https://raw.githubusercontent.com/tkudlicka/dot/main/bin/dotfiles | bash -s -- --tags comma,seperated,tags
```


### Update

This repository is continuously updated with new features and settings which become available to you when updating.

To update your environment run the `dotfiles` command in your shell:

```bash
dotfiles
```

## TBD
- [ ] nerd font
- [ ] fix readme - add bash
- [ ] fix dotfiles loading script - clone repo
- [ ] neovim - refactor
- [ ] configure ansible valut
- [ ] fix installing cast in brew