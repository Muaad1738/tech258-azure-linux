# Deploying an App with Azure

## Setting Up SSH Key to Use on Azure
```bash 
ssh-keygen -t rsa -b 4096 -C "<YOUR_EMAIL>"
```


## Setting Up Virtual Network

### Description:
- Create a virtual network in Azure for hosting the application and database.
    - Public
![alt text](images/publicsub.png)
    - Private 
![alt text](images/private.png)

## Setting Up Virtual Machine for the App
![alt text](images/createvmm.png)
### Description:
  - Create virtual machines for hosting the application and database services.
    - Ubuntu Pro 22.04 Lts
  - Choose appropriate VM sizes and configurations.
    - Security: standard
    - Size: Standard_B1s
    - Default username: change to "adminuser"
    - Keypair: use your SSH Key 
    - Disk size change from premium SSD to standard SSD
#### Repeat Same Steps for the Database Aswell
  

## Setting Up the Network Security Group for the App

### Description:
  - Create a network security group (NSG) to control inbound and outbound traffic for the application VM.
  -  Define security rules to allow/deny specific traffic based on requirements.
      ![alt text](images/sec.png)
  - In Azure, when using Azure Cosmos DB's API for MongoDB, you do not need to declare or open port 27017 for MongoDB. Azure Cosmos DB's API for MongoDB is a fully managed service that abstracts the underlying infrastructure and networking details from you.

## Connecting to Both Virtual Machines

### Description:
  - Establish SSH connections to the application and database VMs for configuration and management.
  ```bash
  ssh -i "~/.ssh/tech258-muaad-az-key" adminuser@172.187.92.256
  ```
  - Replace the IP with the one on your virtual machine and repeat this step with the database IP aswell.


## Running the App and Databases Script

### Description:
- Use the nano command and insert your script.
  
 ```bash
  #!/bin/bash

echo "Updating..."
sudo apt update -y
echo "Done!"

echo "Upgrading packages..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo "Done!"

echo "Installing Nginx..."
sudo DEBIAN_FRONTEND=noninteractive apt install nginx -y
echo "Done!"

# Configure reverse proxy
sudo sed -i '51s/.*/\t  proxy_pass http:\/\/localhost:3000;/' /etc/nginx/sites-enabled/default

# Change configuration file

echo "Restarting Nginx..."
sudo systemctl restart nginx
echo "Done!"ls

echo "Enabling Nginx..."
sudo systemctl enable nginx
echo "Nginx enabled and started on boot."

# Install Node.js version 20.x
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo DEBIAN_FRONTEND=noninteractive -E bash - && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
echo "Node.js installed!"

# Check Node.js version
echo "Node.js version:"
node -v

# Clone the Git repository
echo "Cloning the Git repository..."
git clone https://github.com/Muaad1738/tech258-sparta-test-app.git ~/tech258-sparta-test-app
echo "Git repository cloned!"

# Navigate to the app folder
echo "Navigating to the app folder..."
cd ~/tech258-sparta-test-app/Sparta_test_folder/app


# set db host env var
export DB_HOST=mongodb://172.31.63.98:27017/posts

# Install app dependencies
echo "Installing app dependencies..."
npm install
echo "App dependencies installed!"

# Install PM2
echo "Installing PM2..."
sudo npm install -g pm2
echo "PM2 installed"


# run the app
#echo "Running the app with PM2..."
pm2 start app.js
echo "App started with PM2!"
```
```bash 
#!/bin/bash
# config needrestart.config
# non interactive into command which install things

# Update
echo Updating...
sudo apt update -y
echo Done!

# Upgrade
echo Upgrading packages...
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo Done!

# Install MongoDB 7.0.6
echo Installing MongoDB 7.0.6...
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt-get update 

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh=2.2.4 mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6


# Configure bind IP in MongoDB config file
echo Configuring MongoDB...
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# Restart MongoDB
echo Restarting MongoDB...
sudo systemctl restart mongod

# Enable MongoDB
echo Enabling MongoDB...
sudo systemctl enable mongod
```

#### Execute scripts to deploy and configure the application and database services on respective VMs.
- Run the database script first and do not forget change the DB_HOST IP when setting up the environmental variable.

## Using the Public IP to Open Your App

### Description:
  - Retrieve the public IP address of the application VM.
  - Access the deployed application using the public IP through a web browser.
  
## Diffrences when deploying a VM with azure than with AWS
- In Azure, assigning a static IP to a VM is a straightforward process. When creating or configuring a VM, you can choose to assign a static IP address to it. Azure allows you to reserve an IP address and associate it with the VM, ensuring that the IP remains constant even if the VM is stopped and started.

# Deloying the app using user data
-  Using user data when creating a VM on Azure automates the process, ensuring consistency, efficiency, and scalability compared to manual input via shell commands.
- you also need to use the absoloute path to locate the app.
  ```bash 
  cd /home/ubuntu/tech258-sparta-test-app/Sparta_test_folder/app
  ```

## Create a VM for the Database
 - Create a Virtual Machine for the database.
 - Assign the correct virtual network and the security settings.
 - Enter the correct working bash script on the user data section
 - Run the Database VM
 - Give it time for it run
## Create a VM for the App
- Follow the steps as above 
- Enter the working bash script for the app
- Once the app VM is ready get the public ID and check the link to see if its running.

# Deploying an app using an image 
- Prepare the Existing VM:
     -    Ensure that your existing VM, which hosts the database, is properly configured and running on Azure.
     -   Verify that your database and all necessary configurations are in place and working correctly.
-    Capture VM Image:
     -    Log in to the Azure Portal.
     -   Navigate to the Virtual Machines section.
     -   Select the VM that hosts the database.
     -  In the VM blade, locate the Capture button (usually under the Operations section) and click on it.
     -   Follow the prompts to capture the VM image. You'll be asked to provide details such as the image name, resource group, etc.
     -   Once the image capture process is complete, Azure will create a generalised image of your VM that can be used to create new VM instances.
- Create a New VM from the Captured Image:
    -    In the Azure Portal, navigate to the Images section under the Compute category.
     -   Locate the image that you captured in the previous step and click on it.
     -   In the image blade, click on the Create VM button.
        Follow the prompts to create a new VM from the captured image. You'll need to provide details such as the VM name, resource group, virtual network settings, etc.
     -   Customiae the VM settings as needed, such as the VM size, disk configurations, authentication settings, etc.
     -   Once the VM creation process is complete, you'll have a new VM instance created from the captured image

- What is an Azure Image and its equivalent on AWS?

    An Azure Image is a snapshot of a virtual machine (VM) that includes the OS disk, configurations, and installed applications. On AWS, the equivalent is called an Amazon Machine Image (AMI).

- What is included in the image, and what is not?

    The image includes the OS disk, configurations, and installed applications. What's not included are temporary or dynamic data, such as runtime logs or user-generated content, to keep the image lightweight and reusable.

- What is the side-effect of creating an image of a VM on Azure?
    
    After creating the image, the original VM is generalised, which means it's sysprep'd, making it unable to log back in without reconfiguration.