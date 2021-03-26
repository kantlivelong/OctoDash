set -e

. /usr/share/debconf/confmodule

db_get octodash/owning_user
USER="$RET"
db_get octodash/owning_group
GROUP="$RET"

sed -i "s/OCTODASH_USER=\w*/OCTODASH_USER=${USER}/g" /etc/default/octodash

