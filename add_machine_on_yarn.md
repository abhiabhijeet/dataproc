Command to add machines in yarn (on master node)
```
sudo -u yarn yarn rmadmin -replaceLabelsOnNode "testing-cluster-w-0.c.projectname.internal=am-prod"
sudo -u yarn yarn rmadmin -replaceLabelsOnNode "testing-cluster-w-1.c.projectname.internal=am-prod" 
yarn rmadmin -refreshQueues
yarn rmadmin -refreshNodes

````


For driver and executor machine \, Launch secondary worker with low 
For Driver machine Datanode and NodeManager both need to be shut down
Driver k liye DN & NM dono off krna hoga

Executor k liye DN off krna hoga
