#!/bin/bash -e

APP_KEY="3e63a622-ea24-4e73-9605-8ac435158383"
APP_ID="158db8b8f2"
BUNDLE_ID="beeHome.it.evergrande.cn"

param_num=$#
echo "param num = ${param_num}"
if [ ${param_num} -lt 3 ]; then
   echo "param error, need 3 params!"
   exit 1
fi

VERSION=$1
FILE_NAME=$2
FILE_PATH=$3
echo "VERSION=${VERSION}"
echo "FILE_NAME=${FILE_NAME}"
echo "FILE_PATH=${FILE_PATH}"

curl -k "https://api.bugly.qq.com/openapi/file/upload/symbol?app_key=${APP_KEY}&app_id=${APP_ID}" --form "api_version=1" --form "app_id=${APP_ID}" --form "app_key=${APP_KEY}" --form "symbolType=2"  --form "bundleId=${BUNDLE_ID}" --form "productVersion=${VERSION}" --form "channel=" --form "fileName=${FILE_NAME}" --form "file=@${FILE_PATH}" --verbose

result=$?
echo "curl result = ${result}"

if [ "${result}" -eq 0 ]; then
   echo "upload symbol success!"
   exit 0
else
   echo "upload symbol failed!"
   exit 1
fi


