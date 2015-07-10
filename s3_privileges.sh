#!/bin/bash

#CURRENT BUCKETS
sxls sx://admin@sx-cluster/ | sed 's|sx://admin@sx-cluster/||g' > bucket.txt

# SET PRIV
for a in `cat bucket.txt`;do 

	cat template.json | sed s"/BUCKET/$a/g" > temp.json
	echo "s3cmd setpolicy temp.json s3://$a"
	s3cmd setpolicy temp.json s3://$a

done
