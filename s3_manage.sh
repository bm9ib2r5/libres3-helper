#!/bin/bash

echo -e "\n"
echo "*******************************"
echo "          SX S3 tool           "
echo "*******************************"
echo -e "\n"

usage="$(basename "$0") [-h] -a (add) -del (delete) -l (list)"

listBuckets () {
	sxls sx://admin@sx-cluster/
}

addBucket () {
	BUCKETADD=$1

	S=$(sxls sx://admin@sx-cluster/ | sed 's|sx://admin@sx-cluster/||g' | grep $BUCKETADD)

	if [ "$BUCKETADD" == "$S" ]; then
		echo "bucket: $BUCKETADD exist"
		exit 1
	else
		echo "Creating bucket: $BUCKETADD"
		sxvol create --owner devel --replica 1 --size 256M sx://admin@sx-cluster/$BUCKETADD
	fi
}

deleteBucket () {
	echo "test"
	BUCKETDEL=$1
	sxrm -r sx://admin@sx-cluster/$BUCKETDEL/
	sxvol remove sx://admin@sx-cluster/$BUCKETDEL/
	
}

NUMARGS=$#
if [ $NUMARGS -eq 0 ]; then
  echo $usage
fi


while getopts 'a:d:lh' option; do
	case "$option" in
		h) echo "$usage"
		   exit 1
		  ;;
		a) ADD=$OPTARG 
		   addBucket $ADD
		  ;;
		d) DEL=$OPTARG
		   echo "del: $DEL"
		   deleteBucket $DEL
		  ;;
		l) listBuckets
		  ;;
		?) echo "invalid argument -$option / $usage"
		   exit 1
		   ;;
	esac
done
