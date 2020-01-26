#!/bin/bash

app_ip=`cd ../terraform/stage && terraform output | grep app_external_ip | awk '{print $3}'`
db_ip=`cd ../terraform/stage && terraform output | grep db_external_ip | awk '{print $3}'`
db_ip_int=`cd ../terraform/stage && terraform output | grep db_internal_ip | awk '{print $3}'`


if [ "$1" == "--list" ] ; then
cat<<EOF
{
    "app": {
        "hosts": [$app_ip],
        "vars": {
            "db_ip_int": "$db_ip_int"
        }
    },
    "db": {
        "hosts": [$db_ip],
    }
}
EOF
else
  echo "{ }"
fi
