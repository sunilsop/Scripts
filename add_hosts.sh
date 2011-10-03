#!/bin/bash

# Sunil.Soprey
# Copyright 2011

#Global
hfile=/etc/hosts
hname=$1
iname=$2 

EXT_USAGE=1
EXT_ERR=2
EXT_OK=0 


if [ $# -ne 2 ]; then
        echo usage: "$0 <hostname> <ip>"
        exit ${EXT_USAGE};
fi

if [ -r "$hfile" -a -w "$hfile" ]; then  
echo "" 1>/dev/null;
else	 
echo "Cannot read/write to ${hfile}. exiting."; 
exit ${EXT_ERR};  
fi

echo "creating rollback" 
bdt=`date '+%Y%d_%H%M'`
cp ${hfile} ${hfile}.rollback_${bdt}; 
if [ $? -eq 1 ]; then  echo "Cannot create rollback. Exiting. " && exit ${EXT_ERR}; fi
echo "done rollback"

cat ${hfile} | grep -v -E '^#' | grep ${hname} 1>/dev/null  

if [ $? -eq 0 ]; then
	echo "exists replacing IP - ${iname} "; 
	cat ${hfile} | sed -e "s/[0-9]*.[0-9]*.[0-9]*.[0-9]*\(.*$hname.*\)/$iname\\1/" >> ${hfile}.tmp
	mv ${hfile}.tmp ${hfile}
else
	echo "Adding host/ip ${iname}/${hname}"
	echo $iname $hname >> ${hfile}
fi 

echo "complete."
exit 0; 

