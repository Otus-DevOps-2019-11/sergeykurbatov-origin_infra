#!/bin/bash
cd /home/appuser/ && git clone https://github.com/express42/reddit.git
cd /home/appuser/reddit && bundle install
cat <<EOF > /etc/systemd/system/puma.service
[Unit]
Description=Puma HTTP Server
After=network.target
[Service]
Type=simple
WorkingDirectory=/home/appuser/reddit/
ExecStart=/usr/local/bin/puma
Restart=always
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now puma.service
systemctl start puma.service
