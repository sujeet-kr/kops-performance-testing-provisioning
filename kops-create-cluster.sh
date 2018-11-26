#!/usr/bin/env bash

KOPS_CLUSTER_NAME=nameOfCluster.k8s.local
AWS_REGION=us-east-2
AWS_AVAILABILITY_ZONE=us-east-2a

EBS_TAG_TMP_VAL="Tags=[{Key=KubernetesCluster,Value=$KOPS_CLUSTER_NAME},{Key=PVPerfTesting,Value=InfluxDBPV}]"

#TODO  check kops installation before trying to create the cluster

kops create -f $KOPS_CLUSTER_NAME.yaml
kops create secret --name $KOPS_CLUSTER_NAME sshpublickey admin -i ~/.ssh/id_rsa.pub
kops update cluster --name=$KOPS_CLUSTER_NAME --yes
kops rolling-update cluster $KOPS_CLUSTER_NAME --yes

#Creating the EBS Persistent Volume
echo
echo "Creating EBS Persistent Volume"
eval aws ec2 create-volume --size 10 --region $AWS_REGION --availability-zone $AWS_AVAILABILITY_ZONE --volume-type gp2 --tag-specifications 'ResourceType=volume,$EBS_TAG_TMP_VAL'
