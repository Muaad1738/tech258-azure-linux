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
git clone https://github.com/Muaad1738/tech258-sparta-app repo
echo "Git repository cloned!"

# Navigate to the app folder
echo "Navigating to the app folder..."
cd repo/app


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

# stopping proccesses
echo stopping processes
pm2 stop all
echo procceses stop

# run the app
#echo "Running the app with PM2..."
pm2 start app.js
echo "App started with PM2!"


