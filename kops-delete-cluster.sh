#!/usr/bin/env bash

#TODO check kops installation before trying to delete cluster

bucket_name=sujeet-pt-kops-state-store
KOPS_CLUSTER_NAME=sujeet.k8s.local
KOPS_STATE_STORE=s3://${bucket_name}

kops delete cluster --name=${KOPS_CLUSTER_NAME} --state=${KOPS_STATE_STORE} --yes