
ch13
 --> IRSA - IAM roles for service accounts
https://aws.amazon.com/blogs/opensource/introducing-fine-grained-iam-roles-service-accounts/

# When you create an eks cluster, go to the console and check the details, you're see something OpenID..., this means any External IDP services can use that to connect to the AWS cluster
When you click on it, you will see the audience, which simply is the services(STS) that are connected to it

Resources required for creating IRSA:
1. IN the EKS cluster, Create
    a. ServiceAccount
    b. Kubernetes Job "it will communicate with the ServiceAccount"

2. In AWS, Create
    a. IAM Policy with (read only) permissions attach to below IAM role
    b. IAM Role "this role will attach the ServiceAccount of the EKS cluster"

    NEXT - Generate a token here  https://jwt.io/

    13--> c3-02-local-values.tf -->c3-02
    Created the OIDC and displayed it in the url.
    Get the arns that will be used in c4-02

    13--> c4-02-irsa-iam-policy-and-role.tf -->c4-02   (THIS IS WHERE I START CREATING OIDC "ROLES")

13--> c4-03-irsa-k8s-service-account.tf I created the service account for the job. 

13--> c4-04-irsa-k8s-job.tf  I created a full job, using service account, the role and sample job
