Command to add machines in yarn (on master node)
```
sudo -u yarn yarn rmadmin -replaceLabelsOnNode "testing-cluster-w-0.c.projectname.internal=am-prod"
sudo -u yarn yarn rmadmin -replaceLabelsOnNode "testing-cluster-w-1.c.projectname.internal=am-prod" 
yarn rmadmin -refreshQueues
yarn rmadmin -refreshNodes

````
