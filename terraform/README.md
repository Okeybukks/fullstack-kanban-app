# KanBan App Infrastructure Creation

For the infrastructure required to deploy the #Kanban application, I have chosen to use #Terraform as the Continuous Integration and Continuous Deployment (CICD) tool and #Ansible for automation.

The cloud infrastructure employed for this deployment comprises AWS EC2 instances, created using Terraform. The Terraform script includes userdata, facilitating the installation of packages required to establish a Kubernetes cluster.

To automate the creation of the Kubernetes cluster, Ansible is employed. The Ansible playbook leverages a dynamic inventory generated with Python. This dynamic inventory script dynamically generates the inventory necessary for the Ansible playbook to connect to the instances created by Terraform. This integration streamlines the process of provisioning and configuring the Kubernetes cluster within the AWS environment.

###  EC2 Creation
To be able to create any infrastructure you must have an AWS account and must have your Access Key ID and Access Key Secret. Store this values in the `.aws/credentials` file. This is assuming you are using a Linux environment. I am using an Ubuntu 20.04 for mine.


Sample `.aws/credentials` file content;
```
[default]
aws_access_key_id=CHANGEME
aws_secret_access_key=changeme
```
To run the terraform script, terraform must be installed on your local system. Click this [Link](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) on how to install terraform on a linux environment.

The following variables are to be changed in the `variables.tf` file; it determines the following;

- instance_count: The number of instance you wish to deploy
- instance_type: The instance type to be created e.g t2.micro
- key_name: The pem key name created to access the created instances/

It should be noted, the value assigned to `instance_count` determines the number of values to assign to variables such as `cidr`, `instance_names` and `availability_zones`.

 Note, the created key is stored in the terraform folder and must be added to your `.gitignore` file to prevent pushing this key to your repo. 

To create the infrastructure run the following commands
```
# Change into the terraform folder
cd fullstack-kanban-app/terraform

# Initialize the terraform project
terraform init

# Checkout the resources to be created.
terraform plan

# Create the infrastructure
terraform apply --auto-approve 
```

With the infrastructure created, you can connect to the created instances and checkout the packages installed. You can run `kubeadm version` on the instance to check the kubeadm version installed. The installation was carried out with the script passed to the userdata of the instance.

### Kubernetes Cluster Creation
With the infrastructure needed for the Kubernertes cluster created, the next task is to create the clusters. One commanding principle of DevOps is automation. Ansible will be use to create the cluster.

Two important files needed by Ansible to automate the cluster creation is a playbook and and inventory. The playbook contains the various commands that are to be run on the created instances while the inventory is a json file that conatins the public dns of the instances that will be part of the cluster.

To automate the creation of this inventory file, Python is utilized. The Python script is contained in the `get_dns.py` file in the `ansible` folder.

For this automation process, ansible must be installed in the host machine which in my case is Linux. Follow this [link](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) for the installation guide.

To create the Kubernetes cluster run the following commands.

```
# Change into the ansible folder.
cd fullstack-kanban-app/ansible

# Run the connection test
ansible -i get_dns.py all -m ping

# Run the ansible playbook
ansible-playbook -i get_dns.py playbook.yaml 
```

Some information worth noting, the current Python script on works with terraform because it runs the `terraform output --json` command in its subprocess. Also, the terraform must output the instance dns for the script to work. Any command that prints out the instances dns outside terraform can be passed to the Python script.

With the above commands, you will be able to create a Kubernetes cluster on AWS without any manual intervention.


