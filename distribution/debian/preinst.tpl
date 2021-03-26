set -e

. /usr/share/debconf/confmodule

db_get octodash/owning_user
USER="$RET"
db_get octodash/owning_group
GROUP="$RET"

# Add User and Group
if ! getent group "$GROUP" >/dev/null; then
  groupadd "$GROUP"
fi
if ! getent passwd "$USER" >/dev/null; then
  adduser --system --no-create-home --ingroup "$GROUP" "$USER"
fi

