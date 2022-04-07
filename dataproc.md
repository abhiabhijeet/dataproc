* Create dataproc cluser depending on the requirement. Here I have created dataproc cluster with 1 master and 2 workers.

`gcloud dataproc clusters create testing-cluster --num-masters 1 --region us-central1 --zone "us-central1-b" --master-machine-type n1-standard-8 --master-boot-disk-size 300 --num-workers 2 --worker-machine-type n1-standard-8 --worker-boot-disk-size 500 --secondary-worker-boot-disk-size 100  --image-version 2.0.29-debian10 --project $PROJECT_NAME --subnet=$SUBNET_NAME`


* After creation of cluster do login in each master and worker of the cluster

* to configure nodelabel on yarn, need to add below property in **yarn-site.xml** on each masters and workers.
`cd /etc/hadoop/conf`

```
<property>
  	<name>yarn.node-labels.enabled</name>
  	<value>true</value>
</property>
<property>
   	<name>yarn.node-labels.fs-store.root-dir</name>
   	<value>/yarn/node-labels</value>
</property>
````


* Now update the vcores value and memory in **yarn-site.xml** on each masters and workers.
Memory:-

  ```
  <property>
    <name>yarn.nodemanager.resource.memory-mb</name>
    <value>98304</value>
    <final>false</final>
    <source>Dataproc Cluster Properties</source>
  </property>
  
  <property>
    <name>yarn.scheduler.maximum-allocation-mb</name>
    <value>98304</value>
    <final>false</final>
    <source>Dataproc Cluster Properties</source>
  </property>
  ````
  
  VCORE:-
  
  ```  
  <property>
    <name>yarn.nodemanager.resource.cpu-vcores</name>
    <value>32</value>
    <final>false</final>
    <source>Dataproc Cluster Properties</source>
  </property>
  
  
    <property>
    <name>yarn.scheduler.minimum-allocation-mb</name>
    <value>1024</value>
    <final>false</final>
    <source>Dataproc Cluster Properties</source>
  </property>
  
   <property>
    <description>
      The maximum allocation for every container request at the RM,       in
      terms of virtual CPU cores. Requests higher than this won't take
      effect, and will get capped to this value.
    </description>
    <name>yarn.scheduler.maximum-allocation-vcores</name>
    <value>32000</value>
  </property>
  ````
 * Now run below command on each resourcemanager:-
  
  `sudo systemctl restart hadoop-yarn-resourcemanager.service`
  
  and verify the changes by checking logs `cd /var/log/hadoop-yarn/`
  
 * To configure multiple nodelabel, need to configure in **capacity-scheduler.xml** on each masters server.

```   
   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels</name>
      <value>am-prod,nodelabelone,nodelabeltwo,nodelabelthree</value>
   </property>
   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels.nodelabelthree.capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels.nodelabelthree.maximum-capacity</name>
      <value>100</value>
   </property>
   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels.nodelabeltwo.capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels.nodelabeltwo.maximum-capacity</name>
      <value>100</value>
   </property>
   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels.am-prod.capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels.am-prod.maximum-capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels.nodelabelone.capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.accessible-node-labels.nodelabelone.maximum-capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels</name>
      <value>am-prod,nodelabelone,nodelabeltwo,nodelabelthree</value>
   </property>
   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels.nodelabelthree.capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels.nodelabelthree.maximum-capacity</name>
      <value>100</value>
   </property>
   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels.nodelabeltwo.capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels.nodelabeltwo.maximum-capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels.am-prod.capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels.am-prod.maximum-capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels.nodelabelone.capacity</name>
      <value>100</value>
   </property>

   <property>
      <name>yarn.scheduler.capacity.root.openx.accessible-node-labels.nodelabelone.maximum-capacity</name>
      <value>100</value>
   </property>
  ````
  
* Run below command on master machine.

`yarn rmadmin -addToClusterNodeLabels "nodelabelone(exclusive=true),am-prod(exclusive=true),nodelabeltwo(exclusive=true),nodelabelthree(exclusive=true)"
`

`yarn rmadmin -refreshNodes`

`sudo systemctl restart hadoop-yarn-resourcemanager.service`
