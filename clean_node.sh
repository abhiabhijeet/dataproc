#!/bin/sh



ssh -o StrictHostKeyChecking=no ubuntu@prod-cluster-m "sudo bash remove-nodes.sh"

echo "Removing shutdown nodes from GCP..."
bash $PWD/remove-terminated.sh



remove-terminated.sh

#!/bin/sh


instance_list=$(gcloud compute instances list --filter="status~'TERMINATED' AND -NAME~'cluster*' AND PREEMPTIBLE='true'" | grep -vw NAME | awk '{print $1}')
zones=$(gcloud compute instances list --filter="status~'TERMINATED' AND -NAME~'cluster*' AND PREEMPTIBLE='true'" | grep -vw NAME | awk '{print $2}' | sort -u)
if [[ ! -z "$instance_list" ]];then
#gcloud compute instances delete $instance_list --quiet
for i in $(echo $zones)
do
gcloud compute instances delete $instance_list --zone $i --quiet &
done
else
echo "Nothing to delete"
fi
