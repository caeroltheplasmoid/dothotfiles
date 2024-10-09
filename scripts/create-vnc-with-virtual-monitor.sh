
# Environment lifetime
sudo firewall-cmd --zone=public --add-port=5900/tcp
sudo firewall-cmd --zone=public --add-port=5900/udp

wayvnc -C $HOME/.config/wayvnc/conf.conf -v -o HEADLESS-1 0.0.0.0 5900
