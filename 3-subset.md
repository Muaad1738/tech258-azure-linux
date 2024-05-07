# Create the 3-Subnet Architecture to Make the Database Private

## Create Virtual Network
- Define and create the virtual network with three subnets:
  - Subnet 1: Application 10.0.2.0
  - Subnet 2: Database (Private) 10.0.4.0
  - Subnet 3: Network Virtual Appliance (NVA) 10.0.3.0
  ![alt text](images/vm3.png)

## Create VMs for App, Database, NVA
- Deploy virtual machines for:
  - Application server
    - Enter the user data with the script.
  - Database server
    - When creating a database VM, selecting "No Public IP" ensures that the VM is not directly accessible from the public internet, enhancing security by restricting access to authorised connections only.
  - Network Virtual Appliance (NVA). 
- When creating the VM's pick availability zones. Zone 1 for the app, 2 for the NVA and 3 for the Database. 
## Test Public IP Accessibility
- Test to ensure public IP addresses are accessible 
- Verify if the database and app VMs can interact using ping
    - SSH into your App VM. 
    - Use the command ``` ping 10.0.4.0```
    - This will then show you the packets of data transfered between the App and DB.
  
  

## Create Route Table
Route tables in Azure are created for efficient traffic management within a DMZ, ensuring that network traffic is directed appropriately between different subnets and resources.
- Set up a route table to manage traffic routing within the virtual network:
  -  Define routes for communication between subnets
  ![alt text](images/routetable.png)
  -  Associate the route table with appropriate subnets
![alt text](images/subnetsss.png)
## Enable IP Forwarding
IP forwarding permits the virtual machine to effectively route and forward network traffic between distinct subnets or networks. This functionality facilitates the NVA's operations in filtering, inspecting, or redirecting traffic, thus enhancing network security and optimising performance.
- Enable IP forwarding on the Network Virtual Appliance (NVA) VM:
  ![alt text](images/nentnet.png)
- Then click enable 
  ![alt text](images/ipconfigcc.png)
  
  ### Access the VM via SSH
  - Use ```sysctl net.ipv4.ip_forward``` This will then return zero to show no packets are being transferred.
  - Check and enable IP forwarding in the configuration
  - use ```sudo nano /etc/sysctl.conf```
    ![alt text](images/nanofile.png) uncomment the line to enable packet forwarding.
  - use ```sudo sysctl -p``` this will then show as one which then shows that the packets are now transferring between the app and DB. 

## Configure IP Tables

Configure IP tables on the NVA for additional security and routing:

- Create Nano File 
- Insert the script 
``` bash 
  # Allow all traffic on the loopback interface (localhost)
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow incoming packets that are part of established connections or related to such traffic
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow outgoing packets that are part of established connections
sudo iptables -A OUTPUT -m state --state ESTABLISHED -j ACCEPT

# Drop incoming packets that are marked as INVALID, which usually means they don't match any known connections
sudo iptables -A INPUT -m state --state INVALID -j DROP

# Allow incoming SSH traffic (port 22) for new and established connections
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# Allow forwarding of TCP traffic from subnet 10.0.2.0/24 to 10.0.4.0/24 on port 27017 (MongoDB)
sudo iptables -A FORWARD -p tcp -s 10.0.2.0/24 -d 10.0.4.0/24 --destination-port 27017 -m tcp -j ACCEPT

# Allow forwarding of ICMP (ping) traffic from subnet 10.0.2.0/24 to 10.0.4.0/24 for new and established connections
sudo iptables -A FORWARD -p icmp -s 10.0.2.0/24 -d 10.0.4.0/24 -m state --state NEW,ESTABLISHED -j ACCEPT

# Set the default policy for incoming packets to DROP, meaning unless explicitly allowed, all incoming packets are dropped
sudo iptables -P INPUT DROP

# Set the default policy for forwarded packets to DROP, meaning unless explicitly allowed, all forwarded packets are dropped
sudo iptables -P FORWARD DROP
```   
- Give the correct permissions using ```sudo chmod +x config-ip-tables.sh```
- Run the Script ```./config-ip-tables.sh```
- Before you run any commands make sure you use sudo update and upgrade. 

### Explaination of the bash script 

1. `# Allow all traffic on the loopback interface (localhost)`
   - This line allows all traffic that is sent or received within the same machine, typically used for communication between different programs running on the same computer.

2. `# Allow incoming packets that are part of established connections or related to such traffic`
   - This line allows incoming network packets that are part of existing connections or are related to those connections, ensuring that established connections can continue to communicate without interruption.

3. `# Allow outgoing packets that are part of established connections`
   - This line allows outgoing network packets that are part of established connections, ensuring that responses to outgoing requests can be sent back without interference.

4. `# Drop incoming packets that are marked as INVALID, which usually means they don't match any known connections`
   - This line drops incoming network packets that are marked as invalid, typically because they do not match any known or established connections, which could potentially be malicious or unwanted traffic.

5. `# Allow incoming SSH traffic (port 22) for new and established connections`
   - This line allows incoming Secure Shell (SSH) traffic on port 22 for both new incoming connections and existing established connections, allowing remote access to the system via SSH.

6. `# Allow forwarding of TCP traffic from subnet 10.0.2.0/24 to 10.0.4.0/24 on port 27017 (MongoDB)`
   - This line allows the forwarding of TCP network traffic from one subnet (10.0.2.0/24) to another subnet (10.0.4.0/24) on port 27017, typically used for MongoDB database connections.

7. `# Allow forwarding of ICMP (ping) traffic from subnet 10.0.2.0/24 to 10.0.4.0/24 for new and established connections`
   - This line allows the forwarding of ICMP (ping) traffic from one subnet (10.0.2.0/24) to another subnet (10.0.4.0/24) for both new incoming ping requests and existing ping responses.

8. `# Set the default policy for incoming packets to DROP, meaning unless explicitly allowed, all incoming packets are dropped`
   - This line sets the default policy for incoming network packets to drop, meaning that unless a specific rule allows them, all incoming packets will be rejected or ignored.

9. `# Set the default policy for forwarded packets to DROP, meaning unless explicitly allowed, all forwarded packets are dropped`
   - This line sets the default policy for forwarded network packets to drop, meaning that unless a specific rule allows them, all forwarded packets will be rejected or ignored. 

## Check Public IP Accessibility Again
- Verify if public IP addresses are still accessible. 


