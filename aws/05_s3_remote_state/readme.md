# 05_s3_remote_state
This example shows how to enable the s3 remote backend. We will first provision
the infrastructure necessary to access the KMS, DynamoDB table and Bucket in the
`s3_backend_infra` folder. 

Next we will create a web server using the s3 backend that will be stored in the 
infrastructure we have just created and that is available in `web_server`.

 