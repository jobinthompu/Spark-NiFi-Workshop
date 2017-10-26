####/root/scripts/nifi-setup.sh####
#download jdk-8u40-linux-x64.tar.gz and place it under /root/script
#download nifi-1.2.0.3.0.0.0-453-bin.tar.gz and place it under /opt/

mkdir -p /usr/jdk64/jdk1.8.0_40
tar -xvf /root/scripts/jdk-8u40-linux-x64.tar.gz -C /usr/jdk64/
ln -s /usr/jdk64/jdk1.8.0_40/bin/java /usr/bin/java
tar -xvf /opt/nifi-1.2.0.3.0.0.0-453-bin.tar.gz -C /opt/
sed -i -e 's/8080/8091/g' /opt/nifi-1.2.0.3.0.0.0-453/conf/nifi.properties
sed -i -e 's/nifi.remote.input.host=/nifi.remote.input.host=node5/g' /opt/nifi-1.2.0.3.0.0.0-453/conf/nifi.properties
sed -i -e 's/nifi.remote.input.socket.port=/nifi.remote.input.socket.port=8055/g' /opt/nifi-1.2.0.3.0.0.0-453/conf/nifi.properties
/opt/nifi-1.2.0.3.0.0.0-453/bin/nifi.sh start