# Git utility commands

### git stash a specific file

Since git 2.13, there is a command to save a specific path to the stash: git stash push <path>

```sh
git stash push -m "personal-message" path/to/file
```

### git remove pager for "git branch"

```sh
git config --global pager.branch false
```
