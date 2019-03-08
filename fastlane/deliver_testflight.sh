#!/bin/bash

param_num=$#
echo "param num = ${param_num}"
if [ ${param_num} -lt 1 ]; then
   echo "param error"
   echo "call like this ./deliver_appstore.sh \"your ipa path\""
   exit 1
fi

IPA_PATH=$1
echo "IPA_PTH=${IPA_PATH}"

DIR=$(dirname "$0")
echo "DIR=${DIR}"

cd ${DIR}/..

#upload to testfight
fastlane pilot upload -u "hlwprogramdev@evergrande.cn" -a "cn.evergrande.it.beehome" -i "${IPA_PATH}" -p 1404189085 -b true --verbose
