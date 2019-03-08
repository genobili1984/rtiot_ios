#!/bin/bash -e

show_help()  {
   printf "使用方法如下open_platform_update.sh -v 1.1.0 -n 1 -e test -c \"[1,2,3]\" -d \"[1]\" -w /tmp \n \
         -v 指定版本号,格式如1.1.0  \n \
         -n 是否拉取最新的预制数据，1:服务器即时生成最新的预制数据， 0:服务器使用缓存数据 \n \
         -e 指定拉取的环境， 取值为 dev,test,prod \n \
         -w 指定工程文件所在的路径，默认是脚本文件目录上一级 \n   \
         -c 指定需要更新的开放平台的分类ID  \n  \
         -d 指定渠道商ID   \n"
   exit 0
}

usage() {
   echo "usage: $0 [-v <version>] [-n <newest zip>] [-e environment] -c category_ids -d distributor_ids" 1>&2;
   exit 0
}

rawurlencode() {
  local string="${1}"
  local strlen=${#string}
  local encoded=""
  local pos c o

  for (( pos=0 ; pos<strlen ; pos++ )); do
     c=${string:$pos:1}
     case "$c" in
        [-_.~a-zA-Z0-9] ) o="${c}" ;;
        * )  printf -v o '%%%02x' "'$c"
     esac
     encoded+="${o}"
  done
  echo "${encoded}"    # You can either set a return variable (FASTER) 
  REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}

while [ $# -eq 1 ]; do
    case $1 in
        -h|--help)
            show_help
            shift 1
            ;;
    *)
       usage
       ;;
    esac
done

while getopts ":v:n:e:w:h:c:d:" option; do
    case "${option}" in
    v)
       VERSION=${OPTARG}
       ;;
    n)
       NEWEST_TAG=${OPTARG}
       ;;
    e)
       ENV=${OPTARG}
       ;;
    w)
       WORKSPACE=${OPTARG}
       ;;
    c)
       CATEGORY=${OPTARG}
       ;;
    d)
       DISTRIBUTOR=${OPTARG}
       ;;
    h)
       show_help
       ;;
    *)
       usage
       ;;
    esac
done

shift $((OPTIND - 1))

echo "VERSION=${VERSION}"
echo "NEWEST_TAG=${NEWEST_TAG}"
echo "ENV=${ENV}"
echo "WORKSPACE=${WORKSPACE}"
echo "CATEGORY=${CATEGORY}"
echo "DISTRIBUTOR=${DISTRIBUTOR}"

if [  "${CATEGORY}x" == "x" ]; then
   echo "category id is empty!"
   CATEGORY="[1,2,3,5,7,8,16,17,18,19,23]"
fi

if [ "${DISTRIBUTOR}x" == "x" ]; then
   echo "distributor is empty!"
   DISTRIBUTOR="[1]"
fi

rawurlencode ${CATEGORY}
CATEGORY=${REPLY}
rawurlencode ${DISTRIBUTOR}
DISTRIBUTOR=${REPLY}
echo "after encode CATEGORY=${CATEGORY}"
echo "after encode DISTRIBUTOR=${DISTRIBUTOR}"

BASE_DIR=$(dirname "$0")
echo "BASE_SIR = ${BASE_DIR}"

if [ "${WORKSPACE}x" == "x" ]; then
   WORKSPACE="${BASE_DIR}/.."
   echo "WORKSPACE=${WORKSPACE}"
fi

ZIP_FILEPATH="/tmp/open_platform.zip"
UNZIP_DIR="/tmp/open_platform"
if [ -f "${ZIP_FILEPATH}" ]; then
   echo "file exists"
   rm ${ZIP_FILEPATH}
fi

if [ -f "${ZIP_FILEPATH}" ]; then
   echo "remove file failed!"
fi

if [ -d "${UNZIP_DIR}" ]; then
   rm -rf ${UNZIP_DIR}
fi

if [ "${NEWEST_TAG}x" == "x" ]; then
    NEWEST_TAG="0"
fi

if [ "${ENV}x" == "x" ]; then
   ENV="test"
fi

if [ "${VERSION}x" == "x" ]; then
   OPEN_PLATFORM_URL="http://jiaju-package-test.xl.cn:8080/api.php?client=Ios&newest=${NEWEST_TAG}&env=${ENV}&category_ids=${CATEGORY}&distributor_ids=${DISTRIBUTOR}"
else
   OPEN_PLATFORM_URL="http://jiaju-package-test.xl.cn:8080/api.php?client=Ios&newest=${NEWEST_TAG}&version=v${VERSION}&env=${ENV}&category_ids=${CATEGORY}&distributor_ids=${DISTRIBUTOR}"
fi

echo "OPEN_PLATFORM_URL=${OPEN_PLATFORM_URL}"

curl -o ${ZIP_FILEPATH} -k "${OPEN_PLATFORM_URL}"

if [ $? -ne 0 ]; then
  echo "download open platform zip file failed!"
  exit 1
fi

if [ ! -f "${ZIP_FILEPATH}" ]; then
   echo "downloaded zip file not exist!"
   exit 1
fi

unzip ${ZIP_FILEPATH} -d ${UNZIP_DIR}

#copy dir to project path
#有些时候不存下H5文件夹
if [ -d "${UNZIP_DIR}/H5" ]; then
    yes | cp -rf ${UNZIP_DIR}/H5 ${WORKSPACE}/SmartHome/
else
    echo "H5 directory not exist!"
    exit 1
fi
yes | cp -rf ${UNZIP_DIR}/Preset ${WORKSPACE}/SmartHome/
yes | cp -rf ${UNZIP_DIR}/PresetImage ${WORKSPACE}/SmartHome/


