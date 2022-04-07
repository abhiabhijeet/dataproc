Command to add machines in yarn (on master node)
sudo -u yarn yarn rmadmin -replaceLabelsOnNode "instance-w.internal=am-prod"
sudo -u yarn yarn rmadmin -replaceLabelsOnNode "sigmoid-nitrodb-cluster-w-1.c.ox-sigmoid-prod.internal=am-prod" 
yarn rmadmin -refreshQueues
yarn rmadmin -refreshNodes
