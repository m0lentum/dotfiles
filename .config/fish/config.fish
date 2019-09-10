# === aliases === #
# ls / lsd
abbr -a -g ls lsd
abbr -a -g l lsd -al
abbr -a -g ll lsd -l
abbr -a -g tree lsd --tree

# git
abbr -a -g ga git add
abbr -a -g gc git commit -v
abbr -a -g gc! git commit -v --amend
abbr -a -g gcn! git commit -v --amend --no-edit
abbr -a -g gl git pull
abbr -a -g gf git fetch
abbr -a -g gco git checkout
abbr -a -g gd git diff
abbr -a -g gsh git show
abbr -a -g gst git status
abbr -a -g gb git branch
abbr -a -g gsta git stash
abbr -a -g gstp git stash pop
abbr -a -g glg git log --stat
abbr -a -g glga git log --stat --graph --all
abbr -a -g glo git log --oneline
abbr -a -g gloa git log --oneline --graph --all
abbr -a -g grh git reset HEAD

# pacman
abbr -a -g pacin sudo pacman -S
abbr -a -g pacrm sudo pacman -Rns
abbr -a -g pacfiles pacman -Fs

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

