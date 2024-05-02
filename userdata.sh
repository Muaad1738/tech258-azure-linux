#!/bin/bash

# Navigate to the app folder
echo "Navigating to the app folder..."
cd repo/app
echo "inside app folder"

export DB_HOST=mongodb://10.0.4.4:27017/posts

npm install

echo kill previous 
pm2 kill
echo done!

echo start
pm2 start app.js
echo done!