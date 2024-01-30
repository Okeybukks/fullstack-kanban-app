# Unveiling Komiser: Your Cloud Cost Optimizer and Guardian
### Introduction:
Komiser is not just a name, it's a promise. A promise to gain control over your cloud infrastructure, to optimize costs, and to maximize efficiency. In today's fast-paced digital world, cloud adoption is soaring, but so are the associated costs. This is where Komiser steps in, acting as your trusted cloud-environment inspector, helping you navigate the intricate web of cloud pricing and uncover hidden fees.

According to the State of FinOps 2022 report, teams are still struggling with the following challenges:

![alt text](8.jpeg)

We’ll explore how to use Komiser to empower engineers to optimize their cloud spend while following the [FinOps principles](https://www.finops.org/framework/principles/). Learn more in Komiser [documentation](
https://docs.komiser.io/welcome/overview).

### How to get Komiser

Embrace the ease! Getting started with Komiser is a breeze. Simply head over to [Komiser](https://www.komiser.io/), no credit card is required, just pure cloud expertise at your fingertips.

### Why Komiser is the Best:
- *Holistic Approach*: Unlike limited point solutions, Komiser offers a comprehensive suite of features to address all your cloud cost and security needs.
- *User-Friendly Interface*: The intuitive dashboard makes cloud management a breeze, even for non-technical users.
- *Continuous Improvement*: Komiser is constantly evolving, adding new features and integrations to stay ahead of the curve in the ever-changing cloud landscape.
- *Expert Support*: Our team of cloud enthusiasts is always on hand to answer your questions and guide you on your optimization journey.

### Features:
- *Multi-cloud Visibility*: Breaking down the silos! Komiser connects to multiple cloud accounts, including AWS, Azure, and GCP, providing a consolidated view of your entire cloud landscape.
- *Cost Optimization and Management*: It finds where you're spending money unnecessarily by looking closely at how you use resources. Komiser studies the details and gives you personalized tips on saving money. This includes adjusting your resources to the right size and finding cheaper options that still work well. It's like getting advice on how to spend less while keeping things running smoothly.
- *Budget & Spend Monitoring*: It's like having a helpful tool to manage your expenses and stay in control. Keep a close eye on your budget with alerts and real-time tracking. Avoid surprises and make sure your spending on cloud services stays within your plan. 
- *Security & Compliance*: Komiser helps you maintain a secure cloud environment by identifying security vulnerabilities and ensuring compliance with regulations.
- *Automated Insights and Reporting*: No more manual data crunching! Komiser automatically generates comprehensive reports on your cloud usage and cost breakdowns, saving you precious time and effort.


### Demo:
To sure the capabilities of Komiser, Komiser was installed on an EC2 instance running on AWS. The installation process was a straight and an easy one. For the Demo, the EC2 instance is running on a Linux operating system. To install run this commands;

```
wget https://cli.komiser.io/latest/komiser_Linux_x86_64 -O komiser
chmod +x komiser
sudo mv komiser /usr/bin
```

The above commands install komiser as well as make it executable. The komiser command requires a passed whenever you want to start the komiser server.

This configuration file contains information needed to run the komiser server. Information such as credentials of the cloud platform needed to authenticate komiser to its cloud resources, database needed to persist data collected by the server to increase speed of subsequent data collection, Kubernetes configuration file to sync with any Kubernetes cluster etc.

This is the sample configuration used for this demo;
```
[[aws]]
name="Admin-account"
source="CREDENTIALS_FILE"
path=".aws/credentials"
profile="default"
komiser start --config config.toml 
[[k8s]]
name="demo-account"
path="/home/ubuntu/.kube/config"

[sqlite]
file="komiser.db"
```

To allow komiser access to the AWS account, an access key ID and access secret key has to be generated and stored in a file in the system. The path of this file is passed to `path` of the `[[aws]]` block while the block name of the credentials is passed to `profile`.

This is a sample file containing the AWS credentials;

```
[default] # block name
region=us-east-1
aws_access_key_id=AKIAIOSFODNN7EXAMPLE
aws_secret_access_key=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

To start the komiser server run this command;

```
komiser start --config config.toml
```

In this demo, the created config.toml is located in the root directory. To access the komiser server go to publicip:3000. The instance should have a public IP which is used to access the komiser server on port 3000.

Below are images from the demo;

#### Komiser Running
![alt text](5.jpeg)

#### Some resources incuring cost
![alt text](1.jpeg)
![alt text](2.jpeg)
![alt text](4.jpeg)

#### Komiser has the ability to take you to resources incurring cost
![alt text](6.jpeg)
![alt text](3.jpeg)

#### Thanks to Komiser, an instance running since July of 2023 was discovered.
![alt text](7.jpeg)

### Conclusion:
*Komiser is more than just a tool; it's a partner in your cloud success as showcased on their [website](https://www.komiser.io/), It empowers you to make informed decisions, optimize your spending, and unlock the full potential of your cloud infrastructure. With Komiser by your side, you can say goodbye to cloud cost confusion and hello to a secure, efficient, and cost-effective cloud experience.*