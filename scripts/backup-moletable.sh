#! /usr/bin/env nix-shell
#! nix-shell -p borgbackup -i bash

# note: environment variables defining the repo location are set in configuration-moletable.nix
# so that they are also in effect when using the borg command manually

# some helpers and error handling:
echo() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

echo "Starting backup"

borg create                         \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
				    \
    ::'{hostname}-{now}'            \
    /data/videos                    \
    /data/pictures                  \
    /data/books                     \
    /data/games/Livesplit_1.4.5     \
    /data/music                     \
    /data/documents                 \
    /data/zotero                    \
    /data/steam-windows/steamapps/common/Beat\ Saber/UserData \
    /data/steam-windows/steamapps/common/Beat\ Saber/Beat\ Saber_Data/CustomLevels \
    /home/mole/stuff                \
    /home/mole/.config/krita*       \
    /home/mole/.config/Allusion/backups \

backup_exit=$?

echo "Pruning repository"

borg prune                          \
    --list                          \
    --show-rc                       \
    --keep-within 30d               \

prune_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))

if [ $global_exit -eq 0 ]; then
    echo "Backup and Prune finished successfully"
elif [ $global_exit -eq 1 ]; then
    echo "Backup and/or Prune finished with warnings"
else
    echo "Backup and/or Prune finished with errors"
fi

exit $global_exit
