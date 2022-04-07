#! /bin/bash
num=$2
instance_list=""
for (( c=1; c<=num; c++ ))
do
   name=$1"-"$(date +%s%N | md5sum | cut -c -20)
   gcp_host=$name".c.prod.internal"
   echo $gcp_host | ssh ubuntu@prod-cluster-m "sudo tee -a /etc/hadoop/conf/nodes_include"
   instance_list=$instance_list" "$name
done
gcloud compute instances create $instance_list --custom-vm-type n2d --zone us-central1-a  --network=networkname --subnet=subnetname --custom-cpu=4 --custom-memory=32 --labels process=filter,report=global_filter --image executor-ami --boot-disk-size=100 --boot-disk-type=pd-standard --metadata startup-script='#! /bin/bash
#crontab -l | sed '/^#.*memory_cpu_status.sh/s/#//' | crontab -
host=`hostname -f`
yarn rmadmin -replaceLabelsOnNode "$host"
yarn rmadmin -replaceLabelsOnNode "$host='$1'"'
ssh ubuntu@prod-cluster-m "yarn rmadmin -refreshNodes"
