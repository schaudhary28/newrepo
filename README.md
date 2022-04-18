Pre requisites

Git hub repository with group members as collaborators (remote repository)
Aws cloud9 environment(local repository)
SSH keys for prov,dev,staging environment(to access the deployed code)

Terraform code used to deploy the three environments dev,prod,staging :
alias tf=terraform
tf init
tf validate
tf plan
tf apply --auto-approve

We had created three environments dev,prod and staging. The above terraform commands have been used to run all the three commands.

Our webservers are in the private subnets and bastion in the public subnets to increase security.

Our module section contains the ALB and ASG configuration

Our demonstration video shows the ALB and ASG configuration

After deploying all the environments we can copy the dns for the load balancers in the output of all deployments and open it up in web browwser

The browser after reloading will show different IP's of vm's on which load balancer is switching the load.

Thank you.
