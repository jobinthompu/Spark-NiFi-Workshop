ranger_user=rangeradmin   #set this to DB user you wish to own Ranger schema in RDBMS
ranger_pass=BadPass#1    #set this to password you wish to use
yum install -y postgresql-jdbc*
chmod 644 /usr/share/java/postgresql-jdbc.jar
echo "CREATE DATABASE ranger;" | sudo -u postgres psql -U postgres
echo "CREATE USER ${ranger_user} WITH PASSWORD '${ranger_pass}';" | sudo -u postgres psql -U postgres
echo "ALTER DATABASE ranger OWNER TO ${ranger_user};" | sudo -u postgres psql -U postgres
echo "GRANT ALL PRIVILEGES ON DATABASE ranger TO ${ranger_user};" | sudo -u postgres psql -U postgres
sed -i.bak s/ambari,mapred/${ranger_user},ambari,mapred/g /var/lib/pgsql/data/pg_hba.conf
cat /var/lib/pgsql/data/postgresql.conf | grep listen_addresses
#make sure listen_addresses='*'
ambari-server setup --jdbc-db=postgres --jdbc-driver=/usr/share/java/postgresql-jdbc.jar
service ambari-server stop
service postgresql restart
service ambari-server start
echo "john/HDF@HORTONWORKS.COM
george/HDF@HORTONWORKS.COM
kevin/HDF@HORTONWORKS.COM
steve/HDF@HORTONWORKS.COM" > /tmp/usergroup.txt