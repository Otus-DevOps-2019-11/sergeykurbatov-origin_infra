#!/bin/bash
cd /home/appuser/ && git clone https://github.com/express42/reddit.git
cd /home/appuser/reddit && bundle install
puma -d

