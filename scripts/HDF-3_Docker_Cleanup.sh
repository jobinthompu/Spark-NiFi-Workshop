####Reset Script for HDF-3.0 Image By Jobin George####

#mkdir /root/node1_files
#scp node1:/HDF/mydata.json /root/node1_files/
#scp node1:/root/scripts/config.json /root/node1_files/
#scp node1:/etc/ganglia/gmetad.conf /root/node1_files/
#scp node1:/etc/ganglia/gmond.conf /root/node1_files/
#bash /root/.sys/stop_cluster.sh
#docker commit node2 hdp/master

bash /root/.sys/recreate_cluster.sh
ssh -o "StrictHostKeyChecking no" node1 'wget -nv http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.5.1.0/ambari.repo -O /etc/yum.repos.d/ambari.repo'
ssh -o "StrictHostKeyChecking no" node1 'yum clean all'
ssh -o "StrictHostKeyChecking no" node1 'yum install ambari-server -y'
ssh -o "StrictHostKeyChecking no" node1 'service postgresql initdb'
ssh -o "StrictHostKeyChecking no" node1 '/etc/init.d/postgresql start'
ssh -o "StrictHostKeyChecking no" node1 'ambari-server setup -s'
ssh -o "StrictHostKeyChecking no" node1 'ambari-server install-mpack --mpack=http://public-repo-1.hortonworks.com/HDF/centos7/3.x/updates/3.0.0.0/tars/hdf_ambari_mp/hdf-ambari-mpack-3.0.0.0-453.tar.gz'
ssh -o "StrictHostKeyChecking no" node1 'ambari-server start'
ssh -o "StrictHostKeyChecking no" node1 'rm -rf /var/lib/ambari-server/resources/stacks/HDP'

ssh -o "StrictHostKeyChecking no" node2 'yum remove ambari-agent -y'
ssh -o "StrictHostKeyChecking no" node3 'yum remove ambari-agent -y'
ssh -o "StrictHostKeyChecking no" node4 'rm /opt/HDF-1.2.0.0-91.tar.gz'
ssh -o "StrictHostKeyChecking no" node5 'rm /opt/HDF-2.0.0.0-579.tar.gz'
ssh -o "StrictHostKeyChecking no" node5 'wget -nv http://public-repo-1.hortonworks.com/HDF/3.0.0.0/nifi-1.2.0.3.0.0.0-453-bin.tar.gz -O /opt/nifi-1.2.0.3.0.0.0-453-bin.tar.gz'
ssh -o "StrictHostKeyChecking no" node5 'rm /root/scripts/nifi-setup.sh'
ssh -o "StrictHostKeyChecking no" node5 "cat << 'EOL' >> /root/scripts/nifi-setup.sh
####/root/scripts/nifi-setup.sh####
mkdir -p /usr/jdk64/jdk1.8.0_40
tar -xvf /root/scripts/jdk-8u40-linux-x64.tar.gz -C /usr/jdk64/
ln -s /usr/jdk64/jdk1.8.0_40/bin/java /usr/bin/java
tar -xvf /opt/nifi-1.2.0.3.0.0.0-453-bin.tar.gz -C /opt/
sed -i -e 's/8080/8091/g' /opt/nifi-1.2.0.3.0.0.0-453/conf/nifi.properties
sed -i -e 's/nifi.remote.input.host=/nifi.remote.input.host=node5/g' /opt/nifi-1.2.0.3.0.0.0-453/conf/nifi.properties
sed -i -e 's/nifi.remote.input.socket.port=/nifi.remote.input.socket.port=8055/g' /opt/nifi-1.2.0.3.0.0.0-453/conf/nifi.properties
/opt/nifi-1.2.0.3.0.0.0-453/bin/nifi.sh start"

#SPARK LAB:
ssh -o "StrictHostKeyChecking no" node5 'rm /root/spark-streaming/nifi-spark-receiver-1.0.0.jar'
ssh -o "StrictHostKeyChecking no" node5 'rm /root/spark-streaming/nifi-site-to-site-client-1.0.0.jar'
ssh -o "StrictHostKeyChecking no" node5 'wget -nv http://central.maven.org/maven2/org/apache/nifi/nifi-spark-receiver/1.3.0/nifi-spark-receiver-1.3.0.jar -O /root/spark-streaming/nifi-spark-receiver-1.3.0.jar'
ssh -o "StrictHostKeyChecking no" node5 'wget -nv http://central.maven.org/maven2/org/apache/nifi/nifi-site-to-site-client/1.3.0/nifi-site-to-site-client-1.3.0.jar -O /root/spark-streaming/nifi-site-to-site-client-1.3.0.jar'
ssh -o "StrictHostKeyChecking no" node5 '/etc/init.d/postgresql start'
ssh -o "StrictHostKeyChecking no" node5 'ambari-server start'
ssh -o "StrictHostKeyChecking no" node5 'sleep 60'
ssh -o "StrictHostKeyChecking no" node5 'ambari-server status'
ssh -o "StrictHostKeyChecking no" node5 '/var/lib/ambari-server/resources/scripts/configs.sh set node5 HDP spark-defaults "spark.driver.extraClassPath" "/opt/nifi-1.2.0.3.0.0.0-453/lib/nifi-framework-api-1.2.0.3.0.0.0-453.jar:/root/spark-streaming/nifi-spark-receiver-1.3.0.jar:/root/spark-streaming/nifi-site-to-site-client-1.3.0.jar:/opt/nifi-1.2.0.3.0.0.0-453/lib/nifi-api-1.2.0.3.0.0.0-453.jar:/opt/nifi-1.2.0.3.0.0.0-453/lib/bootstrap/nifi-utils-1.2.0.3.0.0.0-453.jar:/opt/nifi-1.2.0.3.0.0.0-453/work/nar/framework/nifi-framework-nar-1.2.0.3.0.0.0-453.nar-unpacked/META-INF/bundled-dependencies/nifi-client-dto-1.2.0.3.0.0.0-453.jar:/opt/nifi-1.2.0.3.0.0.0-453/work/nar/framework/nifi-framework-nar-1.2.0.3.0.0.0-453.nar-unpacked/META-INF/bundled-dependencies/httpcore-nio-4.4.5.jar" '
ssh -o "StrictHostKeyChecking no" node5 'sleep 20'
ssh -o "StrictHostKeyChecking no" node5 'ambari-server stop'
ssh -o "StrictHostKeyChecking no" node1 'ambari-server stop'
scp /root/node1_files/mydata.json node1:/HDF/
scp /root/node1_files/config.json node1:/root/scripts/
scp /root/node1_files/.bash_profile node1:/root/.bash_profile