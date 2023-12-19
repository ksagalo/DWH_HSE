#!/bin/sh
set -e

echo "Clearing data"
sudo rm -rf ./data
sudo rm -rf ./data-slave

echo "docker compose down"
sudo docker compose down

sudo docker rm -f $(sudo docker ps -aq)
sudo docker rmi -f $(sudo docker images -aq)

sudo docker compose up -d  postgres_master

echo "Starting postgres_master node..."
sleep 30

echo "Prepare replica config..."
sudo docker exec -it postgres_master sh /etc/postgresql/init-script/init.sh
echo "Restart master node"
sudo docker compose restart postgres_master
sleep 30

echo "Starting slave node..."
sudo docker compose up -d  postgres_slave
sleep 30

echo "Server configured and replicated succesfully"

echo "drop/create gmv table..."
docker exec -it postgres_slave psql -U postgres -c "
DROP TABLE IF EXISTS gmv;
CREATE TABLE gmv AS
SELECT
    pu.store_id,
    pr.category_id,
    SUM(pi.product_count * pi.product_price) AS sales_sum
FROM
    purchases AS pu
JOIN
    purchase_items AS pi ON pu.purchase_id = pi.purchase_id
JOIN
    products AS pr ON pi.product_id = pr.product_id
GROUP BY
    pu.store_id, pr.category_id;
"

echo "drop/create gmv view..."
docker exec -it postgres_slave psql -U postgres -c "
DROP VIEW IF EXISTS gmv;
CREATE OR REPLACE VIEW gmv AS
SELECT * FROM gmv;"

echo "select * from gmv..."
docker exec -it postgres_slave psql -U postgres -c "SELECT * FROM gmv;"

exec "$@"


