# gcd - Git worktree navigator

`gcd` lets you quickly navigate to Git worktrees on your filesystem.

`cdg` lets you quickly navigate to directories within your current worktree.

![Preview](gcd.gif)

## Dependencies

* [eza](https://github.com/eza-community/eza) (required)

* [fzf](https://github.com/junegunn/fzf) (required)

* [fd](https://github.com/sharkdp/fd) (optional)

```bash
sudo apt install eza fzf fd-find
```

## Installation

* Clone this repository to `~/.config/git/gcd`:

```bash
mkdir -p ~/.config/git
git clone https://gitlab.com/davvid/gcd.git ~/.config/git/gcd
```

* Edit your `~/.bashrc` or `~/.zshrc` and add this snippet:

```bash
if test -f ~/.config/git/gcd/gcd.sh
then
    source ~/.config/git/gcd/gcd.sh
fi
```

## Configuration

`gcd` searches for worktrees in `$HOME` by default.

`gcd` can be configured to search in other directories by setting the
`gcd.paths` git config variable:

```bash
git config --global --add gcd.paths '$HOME/src'
git config --global --add gcd.paths '$HOME/dev'
```

`$VARIABLES` are expanded by `gcd` so that you can reuse your git configuration
in more scenarios.

`gcd` traverses two levels deep into the configured paths by default.
You can configure `gcd` to search deeper by setting the `gcd.depth` variable.

```bash
git config --global gcd.depth 3
```

*NOTE*: higher depth values cause more disk IO and can have an impact on performance.
