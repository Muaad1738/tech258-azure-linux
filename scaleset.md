# VM Scale Set Deployment Guide

## Preparing for VM Scale Set Creation:

1. **Plan Resources:**
   - Determine the VM size, image, and other configurations needed for your application.
   - Ensure that your Azure subscription has the necessary resources available.

2. **Test the Application:**
   - Ensure that your application works as expected on a single VM.
   - Test the scalability and performance of your application to understand potential bottlenecks.

3. **Networking Configuration:**
   - Set up virtual networks, subnets, and security groups as needed for your VMs.

## Creating VM Scale Set:

1. **Azure Portal:**
   - Navigate to the Azure Portal.
   - Click on "Create a resource" and search for "Virtual Machine Scale Set".
- ![alt text](images/createvmss.png)
   - Follow the wizard to configure the VM Scale Set, including VM size, image, networking, and scaling options.


## Testing VM Scale Set:

1. **Verification:**
   - Once the VM Scale Set is created, verify that instances are provisioned and running correctly.
   - Test the scalability by manually increasing or decreasing the instance count.

2. **Load Testing:**
   - Conduct load testing to ensure that the VM Scale Set can handle expected levels of traffic.
   - Monitor performance metrics such as CPU usage, memory utilization, and response times.

## Understanding Load Balancers:

- **What is a Load Balancer:**
  - A load balancer distributes incoming network traffic across multiple VM instances.
  - It ensures high availability and reliability by evenly distributing requests.

- **Why Load Balancer is Needed:**
  - Load balancers prevent any single VM from becoming a bottleneck by distributing traffic evenly.
  - They enhance fault tolerance and scalability by automatically routing traffic away from failed instances.

## Managing Instances:

- **Reimaging vs. Upgrading:**
  - **Reimaging:** Reimaging a VM restores it to its original state using the base image. This process removes any changes made to the VM since its creation.
  - **Upgrading:** Upgrading a VM involves updating its software, OS, or configurations while preserving data and applications.

## Creating an Unhealthy Instance (for Testing):

1. **Introduction of Faults:**
   - Simulate faults by intentionally causing issues such as network disruptions or application crashes on a VM instance.

2. **Monitoring Health Probes:**
   - Configure health probes to monitor the health of VM instances.
   - Observe how the faulty instance is marked as unhealthy based on health probe results.

## SSH into an Instance in VM Scale Set:

1. **Using Azure Portal:**
   - Navigate to the VM Scale Set in the Azure Portal.
   - Select an instance from the list and click on "Connect".
   - Follow the instructions to SSH into the selected instance.

2. **Using Azure CLI:**
   - Use Azure CLI to retrieve the public IP address of a specific instance in the VM Scale Set.
   - SSH into the instance using the public IP address and SSH key.

## Deleting VM Scale Set and Associated Resources:

1. **Azure Portal:**
   - Navigate to the VM Scale Set in the Azure Portal.
   - Select "Delete" and confirm the deletion. This will delete all associated resources.
aa 


