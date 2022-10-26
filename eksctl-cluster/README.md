#eks ctl

eksctl create cluster \
--name sosotech \
--version 1.22 \
--region us-east-1 \
--nodegroup-name linux-nodes \
--node-type t3.medium \
--nodes 2



aws eks --region us-east- describe-cluster --name sosotech --query cluster.status

aws eks --region us-east-1 update-kubeconfig --name sosotech

eksctl delete cluster --region=us-east-1 --name=sosotech
