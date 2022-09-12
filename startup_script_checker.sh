#!/bin/bash
[ -z "$GCP_PROJECT" ] && echo "Need to set GCP_PROJECT" && exit 1;

virtual_machines_list=`gcloud compute instances list --project $GCP_PROJECT --format="value(name)"` 
SCRIPTS_DIR_BASE=${GCP_PROJECT}-startuscripts
SCRIPTS_DIR=${SCRIPTS_DIR_BASE}-`date "+%Y-%m-%d"`
mkdir -p $SCRIPTS_DIR
for virtual_machine in $virtual_machines_list
do
  echo "CHECKING ${virtual_machine}:"
  vm_startup_script=${SCRIPTS_DIR}/${virtual_machine}-`date "+%Y-%m-%dT%H:%M:%S%z"`
  vm_gcloud_log="${vm_startup_script}.log"
  gcloud --project $GCP_PROJECT compute instances describe \
    $virtual_machine --format="value(metadata.items.startup-script)" \
    | tee -a $vm_startup_script
done  
