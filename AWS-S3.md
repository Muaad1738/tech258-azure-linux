# AWS S3

## What is AWS S3

AWS S3 is a scalable object storage service by Amazon, commonly used for hosting static websites, storing blobs of data, and managing buckets. It provides high redundancy, ensuring data durability and availability.

## SSH into the Instance

To interact with AWS services from your instance, you'll need to install the AWS CLI. Here's how:

- `sudo apt-get update`: Updates package lists for upgrades.
- `sudo apt-get install -y python3-pip`: Installs Python 3 package manager.
- `sudo pip3 install awscli`: Installs AWS CLI.
- `alias python=python3`

## AWS Configuration

###  `aws configure`

To interact with AWS services using the AWS CLI, you need to configure your credentials.

This command will prompt you to enter your AWS Access Key ID, AWS Secret Access Key, default region, and default output format. Once configured, the AWS CLI will use these credentials to authenticate your requests to AWS services.

### `aws help`

This command will provide you with information on available S3 commands and their usage.

### `aws s3 ls`

This command will display a list of all S3 buckets along with their creation dates.


## AWS S3 Commands

### `aws s3 mb s3://tech258-muaad-first-bucket`

This command creates a new S3 bucket named "tech258-muaad-first-bucket". The `mb` stands for "make bucket".

### `aws s3 sync s3://tech258-muaad-first-bucket .`

This command synchronises the contents of the S3 bucket "tech258-muaad-first-bucket" with the current directory on your local machine.

### `aws s3 rm s3://tech258-muaad-first-bucket --recursive` 

This command deletes all files and objects within the S3 bucket "tech258-muaad-first-bucket". The `--recursive` flag indicates that it will delete all contents recursively.

### `aws s3 rm sync s3://tech258-muaad-first-bucket>/test.txt`

This seems to be an incorrect command. If you intended to delete a file named "test.txt" within the bucket, you should use `aws s3 rm s3://tech258-muaad-first-bucket/test.txt`.

### `aws s3 cp test.txt s3://tech258-muaad-first-bucket`

This command copies the local file "test.txt" to the S3 bucket "tech258-muaad-first-bucket".

### `aws s3 rb s3://tech258-muaad-first-bucket --force` 

This command forcefully deletes the S3 bucket "tech258-muaad-first-bucket" and all its contents. The `--force` flag is used to bypass confirmation prompts.

**Caution:** The `aws s3 rm` and `aws s3 rb` commands can be dangerous, especially when used with the `--recursive` or `--force` flags, as they permanently delete data from your S3 bucket. Confirm before executing these commands.


## Using Python Boto3

### List all the S3 buckets:
```python
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# List all S3 buckets
response = s3.list_buckets()

# Print the bucket names
print("List of S3 Buckets:")
for bucket in response['Buckets']:
    print(bucket['Name'])
```
### Create an S3 bucket named tech258-muaad-test-boto3:
``` python
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Create S3 bucket
s3.create_bucket(Bucket='tech258-muaad-test-boto3')

print("S3 bucket 'tech258-muaad-test-boto3' created successfully")
```

### Upload data/file to the S3 bucket
``` python
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Upload file to S3 bucket
s3.upload_file('/home/ubuntu/local_file_path', 'tech258-muaad-test-boto3', 'example_file.txt')

print("File uploaded to S3 bucket 'tech258-muaad-test-boto3'")
```

### Download/retrieve content/file from the S3 bucket
``` python 
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Download file from S3 bucket
s3.download_file('tech258-muaad-test-boto3', 'example_file.txt', '/home/ubuntu/local_file_path')

print("File downloaded from S3 bucket 'tech258-muaad-test-boto3'")
```
### Delete content/file from the S3 bucket
``` python 
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Delete file from S3 bucket
s3.delete_object(Bucket='tech258-muaad-test-boto3', Key='example_file.txt')

print("File deleted from S3 bucket 'tech258-muaad-test-boto3'")
```
### Delete the bucket
``` python 
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Delete S3 bucket
s3.delete_bucket(Bucket='tech258-muaad-test-boto3')

print("S3 bucket 'tech258-muaad-test-boto3' deleted successfully")
```





