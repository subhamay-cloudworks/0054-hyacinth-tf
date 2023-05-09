# Project Hyacinth: S3 Multipart Upload

A user executes a shell script to split a large file (typically 100 MB or greater) into multiple part files. Then the script initiates the multipart upload and uploads each part file one by one. Once the part files upoload is complte the script completes the multipart upload by merging the part files into the original file.

## Description

Multipart upload allows you to upload a single object as a set of parts. Each part is a contiguous portion of the object's data. You can upload these object parts independently and in any order. If transmission of any part fails, you can retransmit that part without affecting other parts. After all parts of your object are uploaded, Amazon S3 assembles these parts and creates the object. In general, when your object size reaches 100 MB, you should consider using multipart uploads instead of uploading the object in a single operation.

![Project Hyacinth - Design Diagram](https://subhamay-projects-repository-us-east-1.s3.amazonaws.com/0054-hyacinth/hyacinth-architecture-diagram.png)

## Getting Started



### Dependencies

* Create a Customer Managed KMS Key in the region where you want to create the stack..
* Modify the KMS Key Policy to let the IAM user encrypt / decrypt using any resource using the created KMS Key.

### Installing

* Clone the repository in a local hard drive.
* Give execute permission to the bash script s3_multipart_upload.sh
* Create a S3 bucket.

### Executing program

* Change directory where you have cloned the repository and give execute permission to the script
```
cd <script directory>
```
* Provide execute permission to the bash script s3_multipart_upload.sh
```
chmod 755 s3_multipart_upload.sh
```
* Execute the bash script from your local system using the following command
```
sh ./s3_multipart_upload.sh <Filename to be uploaded> <Split size in MB> <Target Bucket Name>

```

## Help

Post message in my blog (https://blog.subhamay.com)


## Authors

Contributors names and contact info

Subhamay Bhattacharyya  - [subhamay.aws@gmail.com](https://blog.subhamay.com)

## Version History

* 0.1
    * Initial Release

## License

This project is licensed under Subhamay Bhattacharyya. All Rights Reserved.

## Acknowledgments

Inspiration, code snippets, etc.
* [Stephane Maarek ](https://www.linkedin.com/in/stephanemaarek/)
* [Neal Davis](https://www.linkedin.com/in/nealkdavis/)
* [Adrian Cantrill](https://www.linkedin.com/in/adriancantrill/)
