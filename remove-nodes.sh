#!/bin/bash
cd $PATH

(curl http://prod-cluster-m:8088/ws/v1/cluster/nodes/ | jq '.nodes.node | .[] | select(.state=="RUNNING") | .["nodeHostName"]') > list-of-nodes
sed -i -e 's/"//g' list-of-nodes

for i in $(echo "prod-cluster-w-0 prod-cluster-w-1"); do
	if [[ -z $(cat list-of-nodes | grep -i "$i") ]]; then
		echo "$i.c.project.internal" >> list-of-nodes
	fi

done
cat list-of-nodes > /etc/hadoop/conf/nodes_include
