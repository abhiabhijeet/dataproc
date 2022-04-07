* Command to add machines in yarn (on master node)
```
sudo -u yarn yarn rmadmin -replaceLabelsOnNode "testing-cluster-w-0.c.projectname.internal=am-prod"
sudo -u yarn yarn rmadmin -replaceLabelsOnNode "testing-cluster-w-1.c.projectname.internal=am-prod" 
yarn rmadmin -refreshQueues
yarn rmadmin -refreshNodes

````


* For drivers and executors machine, Launch secondary worker with low configuration and create image image for that.
* With that image create an instance.
* Now ssh to newly created instances.
* For Executor shutdown the DN and create image(prod-executor-ami).
```
sudo update-rc.d hadoop-hdfs-datanode disable
sudo update-rc.d -f  hadoop-hdfs-datanode remove
sudo systemctl disable hadoop-hdfs-datanode
sudo systemctl stop hadoop-hdfs-datanode
````
gcloud compute instances create nodelabelone --zone us-central1-b  --network=networkname --subnet=sigmoid-openx --preemptible  --custom-cpu=36 --custom-memory=72 --image prod-executor-ami --boot-disk-size=100 --boot-disk-type=pd-standard

* For Driver machine Datanode and NodeManager both need to be shut down and create image(prod-driver-ami) for this.
```
sudo update-rc.d hadoop-yarn-nodemanager disable
sudo update-rc.d -f  hadoop-yarn-nodemanager remove
sudo systemctl disable hadoop-yarn-nodemanager
sudo systemctl stop hadoop-yarn-nodemanage
````
