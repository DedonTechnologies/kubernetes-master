<!-- #### SELF-MANAGED KUBERNETES CLUSTER DEPLOYMENT STEPS

**Purpose: This documentation provides steps to create self-managed kunernetes cluster with KUBEADM**
- **The Operating System is Ubuntu 20.04 LT**
- **Terraform script will work only on AWS**
- **KUBEAM bootstrap scripts are in `user_data` directory**

**Step 1: Assume You have AWSCLI downloaded and Setup with your API keys**
<details><summary>View</summary>
<p>
That was easy!
</p>
</details>

**Step 2: Create and download keypair from CLI**
<details><summary>View</summary>
<p>

 **For Windows Users**
- Open Windows Powershell as Administrator, run 
 ```bash
aws ec2 create-key-pair --region us-xxxx-2 --key-name mykeypair --query 'KeyMaterial' --output text | out-file -encoding ascii -filepath ~/Desktop/mykeypair.pem 
 ```
 - Move to directory where you saved your keypair(`mykeypair.pem`) and run 
 
 ```
 chmod 400 mykeypair.pem
```
Note!
> Your keypair must be created in the same region you intend to create your cluster.
> You must reference the keypair on your deployment script to enable you SSH to nodes

 **For MacOS users**

 ```bash
aws ec2 create-key-pair --key-name myKeypair --query 'KeyMaterial' --output text > mykeypair.pem
 ```

</p>
</details>

**Step 3: Update The Script**
<details><summary>View</summary>
<p>
  
  - `cd` into `k8s-infrastructure-with-terraform` 
  - Update `backend.tf` with an existing `S3` bucket. 
  - If you don't want to save you statefile in any `S3` bucket, comment `backend.tf`.
  - In `terraform.tfvars` update `aws_access_key` with your ***aws_access_key_id*** and `aws_secret_key` with ***aws_secret_access_key***.
  - In `variables.tf.
    - on `line 12`, update the region.
    - on `line 25`, update `ami-042e8287309f5df03`. The AMI must be `Ubuntu 20.04` and must be in the region you intend to create your nodes.

</p>
</details>

**Step 4: Deploy You infrastructures**
<details><summary>View</summary>
<p>

- Open terminal in `k8s-infrastructure-with-terraform` directory and type,

```bash
terraform init # copy and paste individually and wait for one to complete before the other
terraform fmt
terraform validate
terraform plan
terraform apply --auto-approve
```
- Once the infrastructures are successfully deployed, you will see public ip addresses(output) for master and worker nodes. They will look like this:

```bash
Master_pub_ip = "3.80.6.140"
worker01_pub_ip = "3.227.251.158"
worker02_pub_ip = "3.236.16.182"
```
</p>
</details>

**Step 5: Configure Master Node(Controlplane)**
<details><summary>View</summary>
<p>

- SSH into master node 

```bash 
ssh -i ~/path/mykeypair.pem ubuntu@3.80.6.140
```

- Onces your have SSH into master node, run.
  
```bash
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

- Deploy CNI, [calico network interface](https://projectcalico.docs.tigera.io/getting-started/kubernetes/installation/config-options) by running
 
 ```bash
 kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml 
 ```
- Create join token.
  
  ```bash
  sudo kubeadm token create  --print-join-command
  ```
  - You shoud see something like this
  
  ```
  kubeadm join 172.16.0.197:6443 --token nj5zpr.7nedjnucg1dhe6ox --discovery-token-ca-cert-hash sha256:7f876317b4e0c523222765895e4447cd88ca117deb40065b9a6d220b14d2fd7f
  ```
  - Save the join Token
</p>
</details>

**Step 6: Setup worker nodes**
<details><summary>View</summary>
<p>

-  SSH into worker01  

```bash 
ssh -i ~/path/mykeypair.pem ubuntu@3.227.251.158
```
- Add note01 to the cluster by typing:

```bash
 sudo kubeadm join 172.16.0.197:6443 --token nj5zpr.7nedjnucg1dhe6ox --discovery-token-ca-cert-hash sha256:7f876317b4e0c523222765895e4447cd88ca117deb40065b9a6d220b14d2fd7f
```
-  SSH into worker02

```bash 
ssh -i ~/path/mykeypair.pem ubuntu@3.236.16.182
```
- Add note01 to the cluster by typing:

```bash
 sudo kubeadm join 172.16.0.197:6443 --token nj5zpr.7nedjnucg1dhe6ox --discovery-token-ca-cert-hash sha256:7f876317b4e0c523222765895e4447cd88ca117deb40065b9a6d220b14d2fd7f
```
- Close SSH connection on worker nodes 
- Head back to master node and type

```bash
kubectl get node -o wide
kubectl get pod -A
```
</p>
</details>

**Step 7: One Important Thing**
<details><summary>View</summary>
<p>

- Remember NOT to push your `keys` to GitHub repo 
</p>
</details>
  

---
#First
check my s3 buckets so I can add to my code, if no bucket av
$ aws s3 ls

# Secondly
I will create my Key in the powershell. I will modify the code with my key name, and Note the directory the key is saved

$ PS C:\Users\macfe\Documents> aws ec2 create-key-pair --region us-east-1 --key-name collins --query 'KeyMaterial' --output text | out-file -encoding ascii -filepath ~/Documents/collins.pem

Thirsly chnge the key permission to chmod 400
$ PS C:\Users\macfe\Documents> chmod 400 collins.pem


After terraform has been applied. I will copy the public IPs that I will use to ssh into my servers

I will apply my carlico

Master_pub_ip = "100.25.133.178"
worker01_pub_ip = "54.210.18.105"
worker02_pub_ip = "100.26.255.192"


ssh -i collins.pem ubuntu@100.25.133.178     //I will ssh into my master. From here I will create my token to connect to my workers

ssh -i collins.pem ubuntu@54.210.18.105

ssh -i collins.pem ubuntu@100.26.255.192



--in master

# generate the token for the workers
$ sudo kubeadm token create  --print-join-command
 
kubeadm join 172.16.0.188:6443 --token m1etl3.9a7ntwtxrpeg4a97 --discovery-token-ca-cert-hash sha256:e3f17d5149115fa787dfab2933c2a639f2c7d14d778194102281a9eda87d7b3b

--in worker -->