#!/bin/bash
set -e

echo ">>create-replica-user.sh"
sh /etc/postgresql/init-script/create-replica-user.sh
echo ">>backup-master.sh"
sh /etc/postgresql/init-script/backup-master.sh
echo ">>init-slave.sh"
sh /etc/postgresql/init-script/init-slave.sh
