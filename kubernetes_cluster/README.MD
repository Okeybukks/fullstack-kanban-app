It is important to recognize that the Kubernetes cluster created using the Ansible playbook has certain limitations. This is primarily because the automatic creation of AWS resources from the Kubernetes API is not feasible without a cloud controller integrated into the cluster.

For instance, when creating a LoadBalancer service using the generated cluster, the External IP of the service may remain in a pending state. This is due to the service attempting to create a load balancer resource on AWS, but it lacks the necessary capacity to do so. To address this, the Kubernetes API needs a Cloud Controller Manager (CCM) with the capability to manage cloud-specific resources.

It is worth noting that for managed services like Amazon EKS, the Cloud Controller Manager is automatically integrated. However, in the case of a manually created Kubernetes cluster, this integration is not automatic. 

At the moment I have not figured out how to automate the creation of a Kubernetes cluster that has a CCM integrated with it. This is how it is done manually.

### Kubernertes Cluster Creation with CCM integrated.
Having spoken why CCM is important to a Kubernetes cluster, to integrate into a manually created cluster some conditions have to be met.

- Instance hostname:
The instance hostname should be the private dns address of the instance. You can change the hostname of the instance using this command

    ```
    sudo hostnamectl set-hostname $(curl -s http://169.254.169.254/latest/meta-data/local-hostname)
    ```
    This command should be run all instances that will be part of the Kubernetes cluster.

- Instance policy and roles:
 Since we want AWS resources creation from the Kuberbetes API, certain permissions have to be given to the instances. These permissions are stated in the policies and attached to the instance using roles. The controller has more permissions compared to the worker. These permission can be found in the `policy_role.tf` file in the terraform folder.

 - Resource tagging: All resources such as EC2, VPC, Subnets, Security Group has to be tagged with `kubernetes.io/cluster/kubernetes` with value `owned` if these resources are managed by one cluster but if these resources are managed by multiple cluster the value should be `shared`.

 With the above prerequisite set, we can create a cluster using kubeadm. But hold on, this is no differnt from what is implemented in cluster creation using ansible. Beacuse we ant to integrate a CCM, some variable need to be set in a `kube.config` file that will be passed to the `kubeadm init` command. 

 Edit the `kube.config` file.

 ```
 apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
apiServer:
  certSANs:
    - 127.0.0.1
    - <Controller Public IP> # Change me. Public IP of the controller instance
  extraArgs:
    bind-address: "0.0.0.0"
    cloud-provider: external
clusterName: kubernetes
scheduler:
  extraArgs:
    bind-address: "0.0.0.0"
controllerManager:
  extraArgs:
    bind-address: "0.0.0.0"
    cloud-provider: external
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
nodeRegistration:
  name: <worker-instance-hostname> # Change me. Hostname value set in the prerequisite.
  kubeletExtraArgs:
    cloud-provider: external
 ```

 This configuration file is to be used when intializing the cluster in the controller instance. Make sure the change `Controller Public IP` value in **certSANs** and also `name` value in **nodeRegistration**.

 To initialize the cluster run this command on the controller instance;

 ```
 kubeadm init --config kube.config
 ```

 Once initialized, run the commands that has been outputed ny running the initialize command. The `token`, `<control-plane-host>:<control-plane-port>` and `discovery-token-ca-cert-hash` values printed alongside the `kubeadm join` should be noted. These values will be utilized in the `node-kube.config` file used in the worker instance.

 Edit the `node-kube.config` file.
 ```
 ---
apiVersion: kubeadm.k8s.io/v1beta3
kind: JoinConfiguration
discovery:
  bootstrapToken:
    token: <token>  
    apiServerEndpoint: <control-plane-host>:<control-plane-port> # Change me
    caCertHashes:
      - <discovery-token-ca-cert-hash> # Change me
nodeRegistration:
  name: <worker-instance-hostname>
  kubeletExtraArgs:
    cloud-provider: external
 ```

 With the `node-kube.config` properly configured run this command in the worker instance(s).

 ```
 kubeadm join --config=node-kube.config
 ```

 With the Kubernetes cluster created, the next step is to install the the CCM.

 Clone the AWS Controller Repository which  contains the necessary manifest files in the controller instance.

 ```
 git clone https://github.com/kubernetes/cloud-provider-aws.git
 ```

 Navigate to the base directory wich contains the CCM manager 

 ```
 cd cloud-provider-aws/examples/existing-cluster/base
 ```
Run the kubctl command to create the resources
```
kubectl create -k .
```
The `-k` flag uses the kustomize file in the directory.

To get the resources installed run
```
kubectl get ds -n kube-system
```

With the CCM fully integrated you can create a resource such as LoadBalancer service and a loadbalancer resource will be created in AWS.


