#!/bin/sh

# Create a user for rtorrent and assign it to a common uid/gid for convenience.
pw groupadd rtorrent -g 1000
pw useradd rtorrent -m -g 1000 -u 816

# Move rTorrent config to expected location
mv /tmp/rtorrent-flood/.rtorrent.rc /home/rtorrent/.rtorrent.rc

# Update npm to the latest version
npm install -g npm

#npm install -g forever

# rTorrent startup script
chmod 555 /usr/local/etc/rc.d/rtorrent
sysrc -f /etc/rc.conf rtorrent_enable="YES"

# rTorrent Flood startup script
chmod 555 /usr/local/etc/rc.d/rtorrent_flood
sysrc -f /etc/rc.conf rtorrent_flood_enable="YES"

# Create flood folder
cd /home/rtorrent || exit 1

# Download sources
git clone https://github.com/jesec/flood.git
cd flood || exit 1
cp -rf /root/rtorrent/flood/* .

chown -R rtorrent /home/rtorrent

npm install
npm run build

# Start the service
service rtorrent start
service rtorrent_flood start

echo "When creating flood user, put socketdirectory as: /config/.session/rtorrent.sock" > /root/PLUGIN_INFO
