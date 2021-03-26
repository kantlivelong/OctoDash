ln -s /opt/OctoDash/octodash /usr/bin/octodash

sed -i 's/^#*allowed_users=.*$/allowed_users=anybody/g' /etc/X11/Xwrapper.config

systemctl set-default graphical.target
