# alias
git config --global alias.co 'checkout'
git config --global alias.br 'branch'
git config --global alias.ci 'commit'
git config --global alias.st 'status'
git config --global alias.a 'add'
git config --global alias.ps 'push'
git config --global alias.pl 'pull'
git config --global alias.c 'commit -m'
git config --global alias.s 'status'
git config --global alias.b '!f() { git switch "$1" 2>/dev/null || git switch -c "$1"; }; f'
git config --global alias.l "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --decorate --date=short"
git config --global alias.d 'diff'
git config --global alias.ds 'diff --staged'
git config --global alias.unstage 'restore --staged'
git config --global alias.undo 'reset HEAD~1 --mixed'
git config --global alias.am 'commit --amend --no-edit'
git config --global alias.last 'log -1 HEAD --stat'
git config --global alias.root 'rev-parse --show-toplevel'

git config --global init.defaultBranch master
git config --global pull.rebase true
git config --global push.autoSetupRemote true
git config --global diff.algorithm histogram
git config --global diff.colorMoved plain
git config --global diff.mnemonicPrefix true
git config --global commit.verbose true
git config --global column.ui auto
git config --global branch.sort -committerdate
git config --global tag.sort -version:refname
git config --global rerere.enabled true
git config --global rerere.autoupdate true
git config --global pager.branch false
git config --global pager.log false

git config --global fetch.prune true
git config --global rebase.autoStash true
git config --global merge.conflictStyle zdiff3
git config --global push.followTags true
git config --global core.editor nvim
git config --global help.autocorrect prompt
