#!/bin/sh
# set -x

if [ $# -ne 3 ]
then
    echo "Invalid number of parameters passed."
    echo "Usage : sh $0 <Filename to be uploaded> <Split size in MB> <Target Bucket Name"
    exit 1
fi


FILE_NAME=$1
SPLIT_SIZE=$2
TARGET_BUCKET=$3

call_s3upload_api(){
    echo "`date` :: ---------- Part Number: ${i} upload started ------------"
    ETAG=`aws s3api upload-part --bucket ${TARGET_BUCKET} --key ${FILE_NAME} --part-number ${i} --body ${split_file} --upload-id ${UPLOAD_ID}|jq -r ".ETag"`
    echo "`date` :: ---------- Part Number: ${i} uploaded ------------------"
    echo "PartNumber:${i}:ETag:${ETAG}" >> list.txt
}



FILE_SIZE_BYTE=$((`wc -c ${FILE_NAME}|tr -s " "|cut -d" " -f2`))
FILE_SIZE_MB=$((FILE_SIZE_BYTE / 1000000))
regex="^[0-9]M$|^[1-9][0-9]M$|^(100)M$"

split -b ${SPLIT_SIZE} ${FILE_NAME}

echo "`date` :: ${FILE_NAME} splited into `ls x*|wc -l|tr -s " "` parts"

if [ ${FILE_SIZE_MB} -gt 5 ]
then
    echo "`date` :: Size of file ${FILE_NAME} (${FILE_SIZE_BYTE} Bytes) is  greater than 5MB and is eligible for S3 multipart upload."
    if [[ ${SPLIT_SIZE} =~ ${regex} ]]
    then
        start=$(date +%s)
        echo "`date` :: Split Size is in correct format. Initiating the upload..."
        UPLOAD_ID=`aws s3api create-multipart-upload --bucket ${TARGET_BUCKET} --key ${FILE_NAME}|jq -r ".UploadId"`
        echo "`date` :: **************** Multipart upload initiated ****************"
        # echo "Upload Id : ${UPLOAD_ID}"
        i=0
        touch list.txt
        for split_file in `ls x*`
        do
            ((i=i+1))
            call_s3upload_api ${i}, ${split_file}, ${UPLOAD_ID} &
        done

        wait 

        sort --key 2 --field-separator : --numeric-sort list.txt|jq -Rs '{Parts:split("\n")|map(split(":")|{(.[0]):.[1]|tonumber,(.[2]):.[3]}?)}' > list.json
        # echo "==============================list.json====================================="
        # cat list.json

        echo "`date` :: ****************Multipart upload completion started **********"
        aws s3api complete-multipart-upload --multipart-upload file://list.json --bucket ${TARGET_BUCKET} --key ${FILE_NAME} --upload-id ${UPLOAD_ID} > s3_upload_status.txt 

        echo "========================S3 Multipart Upload Status============================"
        cat s3_upload_status.txt
        end=$(date +%s)    
        runtime=$(($end-$start))
        echo "Total execution time: ${runtime} seconds."

        rm -f list.*
        rm -f x*
    else
        echo "Invalid split size format -  correct format is NNM, where N is an integer"
        exit 1
    fi
else
    echo "Size of file ${FILE_NAME} (${FILE_SIZE_BYTE} Bytes) is less than 5MB and not eligible for S3 multipart upload."
    exit 1
fi

echo "`date` :: ****************Multipart upload completed****************"
exit 0




