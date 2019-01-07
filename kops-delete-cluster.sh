#!/usr/bin/env bash

#TODO check kops installation before trying to delete cluster

working_dir=`pwd`
source ./perf-load-gen.cfg

if [ -z $1 ]
then
  kops delete cluster --name=${KOPS_CLUSTER_NAME} --state=${KOPS_STATE_STORE} --yes
else
  influxdb_pod=`kubectl get po -n ${thenamespace} | grep influxdb-jmeter | awk '{print $1}'`
  echo
  echo "Creating a Back up of InfluxDB to /tmp "
  kubectl exec -it -n ${thenamespace} ${influxdb_pod} -- rm -rf ${BACKUP_FOLDER}${BACKUP_NAME}
  kubectl exec -it -n ${thenamespace} ${influxdb_pod} -- rm -f ${BACKUP_ARCHIVE_LOCATION}
  kubectl exec -it -n ${thenamespace} ${influxdb_pod} -- mkdir ${BACKUP_FOLDER}${BACKUP_NAME}
  kubectl exec -it -n ${thenamespace} ${influxdb_pod} -- influxd backup -portable -database ${DATABASE_NAME} ${BACKUP_FOLDER}${BACKUP_NAME}
  kubectl exec -it -n ${thenamespace} ${influxdb_pod} -- tar -cvzf ${BACKUP_ARCHIVE_LOCATION} ${BACKUP_FOLDER}${BACKUP_NAME}
  kubectl exec -it -n ${thenamespace} ${influxdb_pod} -- aws s3 cp ${BACKUP_ARCHIVE_LOCATION} s3://${S3_BUCKET}/${BACKUP_ARCHIVE_NAME}

  sleep 2s

    # if aws s3 cp $BACKUP_ARCHIVE_PATH s3://${S3_BUCKET}/${S3_KEY_PREFIX}latest.tgz; then
    #     echo "Backup file copied to s3://${S3_BUCKET}/${S3_KEY_PREFIX}latest.tgz"
    #   else
    #     echo "Backup file failed to upload"
    #     exit 1
    #   fi
  kops delete cluster --name=${KOPS_CLUSTER_NAME} --state=${KOPS_STATE_STORE} --yes

fi
