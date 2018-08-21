#!/usr/bin/env bash

KOPS_CLUSTER_NAME=sujeet.k8s.local


#TODO  check kops installation before trying to create the cluster


kops create -f $KOPS_CLUSTER_NAME.yaml
kops create secret --name $KOPS_CLUSTER_NAME sshpublickey admin -i ~/.ssh/id_rsa.pub
kops update cluster --name=$KOPS_CLUSTER_NAME --yes
kops rolling-update cluster $KOPS_CLUSTER_NAME --yes