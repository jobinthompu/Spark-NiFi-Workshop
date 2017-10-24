// Import all the libraries required
import org.apache.nifi._
import java.nio.charset._
import org.apache.nifi.spark._
import org.apache.nifi.remote.client._
import org.apache.spark._
import org.apache.nifi.events._
import org.apache.spark.streaming._
import org.apache.spark.streaming.StreamingContext._
import org.apache.nifi.remote._
import org.apache.nifi.remote.client._
import org.apache.nifi.remote.protocol._
import org.apache.spark.storage._
import org.apache.spark.streaming.receiver._
import java.io._
import org.apache.spark.serializer._
object SparkNiFiAttribute {
def main(args: Array[String]) {
        // Build a Site-to-site client config with NiFi web url and output port name[spark created in step 6c]
val conf = new SiteToSiteClient.Builder().url("http://node1:9090/nifi").url("http://node2:9090/nifi").url("http://node3:9090/nifi").portName("spark").buildConfig()
        // Set an App Name
val config = new SparkConf().setAppName("Nifi_Spark_Data")
        // Create a  StreamingContext
val ssc = new StreamingContext(config, Seconds(10))
        // Create a DStream using a NiFi receiver so that we can pull data from specified Port
val lines = ssc.receiverStream(new NiFiReceiver(conf, StorageLevel.MEMORY_ONLY))
        // Map the data from NiFi to text, ignoring the attributes
val text = lines.map(dataPacket => new String(dataPacket.getContent, StandardCharsets.UTF_8))
        // Print the first ten elements of each RDD generated
text.print()
        // Start the computation
ssc.start()
}
}
SparkNiFiAttribute.main(Array())