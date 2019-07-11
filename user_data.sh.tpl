#!/bin/bash
sudo yum install -y ${package}
sudo systemctl start ${package}
sudo systemctl enable ${package}