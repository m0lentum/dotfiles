# === aliases === #
# ls / lsd
abbr -a ls lsd
abbr -a l lsd -al
abbr -a ll lsd -l
abbr -a tree lsd --tree

# git
abbr -a ga git add
abbr -a gc git commit -v
abbr -a gc! git commit -v --amend
abbr -a gcn! git commit -v --amend --no-edit
abbr -a gl git pull
abbr -a gf git fetch
abbr -a gco git checkout
abbr -a gd git diff
abbr -a gsh git show
abbr -a gst git status
abbr -a gb git branch
abbr -a gsta git stash
abbr -a gstp git stash pop
abbr -a glg git log --stat
abbr -a glga git log --stat --graph --all
abbr -a glo git log --oneline
abbr -a gloa git log --oneline --graph --all
abbr -a grh git reset HEAD

# pacman
abbr -a pacin sudo pacman -S
abbr -a pacrm sudo pacman -Rns
abbr -a pacfiles pacman -Fs

# === keybindings === #
fish_hybrid_key_bindings

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

