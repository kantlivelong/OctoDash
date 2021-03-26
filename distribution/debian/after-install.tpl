set -e

. /usr/share/debconf/confmodule

db_get octodash/owning_user
USER="$RET"
db_get octodash/owning_group
GROUP="$RET"

chown -R $USER:$GROUP /opt/OctoDash
chmod -R 775 /opt/OctoDash

if [ ! -e /usr/bin/octodash ]; then ln -s /opt/OctoDash/octodash /usr/bin/octodash; fi

sed -i "s/^#*allowed_users=\w*$/allowed_users=anybody/g" /etc/X11/Xwrapper.config

systemctl set-default graphical.target
