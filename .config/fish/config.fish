# === aliases === #
# ls / lsd
abbr -a ls lsd
abbr -a l lsd -al
abbr -a ll lsd -l
abbr -a tree lsd --tree

# git
abbr -a ga git add
abbr -a gaa git add -A
abbr -a gc git commit -v
abbr -a gc! git commit -v --amend
abbr -a gcn! git commit -v --amend --no-edit
abbr -a gca git commit -a -v
abbr -a gca! git commit -a --amend
abbr -a gcan! git commit -a --amend --no-edit
abbr -a gp git push
abbr -a gpf git push --force-with-lease
abbr -a gl git pull
abbr -a gf git fetch
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gst git status
abbr -a gb git branch
abbr -a gsta git stash
abbr -a gstp git stash pop

# === install fisher === #
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

# === Starship prompt === #
eval (starship init fish)

# === On login autostart === #
# This varies per computer so we don't define it here
if status is-login && functions -q autostart
  autostart
end

