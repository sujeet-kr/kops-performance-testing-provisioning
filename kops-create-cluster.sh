#!/usr/bin/env bash

source ./perf-load-gen.cfg

EBS_TAG_TMP_VAL="Tags=[{Key=Name,Value=Sujeet-PerfTest-InfluxDBPV},{Key=KubernetesCluster,Value=$KOPS_CLUSTER_NAME},{Key=PVPerfTesting,Value=InfluxDBPV}]"

#TODO  check kops installation before trying to create the cluster

# kops create -f $KOPS_CLUSTER_NAME.yaml
kops create secret --name ${KOPS_CLUSTER_NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub
kops replace --force -f ${KOPS_CLUSTER_NAME}.yaml
kops update cluster --name=${KOPS_CLUSTER_NAME} --yes
kops rolling-update cluster ${KOPS_CLUSTER_NAME} --yes

#Creating the EBS Persistent Volume
echo
echo "Creating EBS Persistent Volume"
eval aws ec2 create-volume --size 10 --region ${AWS_REGION} --availability-zone ${AWS_AVAILABILITY_ZONE} --volume-type gp2 --tag-specifications 'ResourceType=volume,${EBS_TAG_TMP_VAL}'

cluster_status=`kops validate cluster | grep "Your cluster ${KOPS_CLUSTER_NAME} is ready"`

while [ "${cluster_status}" != "Your cluster ${KOPS_CLUSTER_NAME} is ready" ]; do
   sleep 20s
   echo "Waiting for Cluster nodes to be ready ..."
   cluster_status=`kops validate cluster | grep "Your cluster ${KOPS_CLUSTER_NAME} is ready"`
done

echo
echo
echo "All Cluster Nodes are ready"
echo
echo
echo `kops validate cluster`