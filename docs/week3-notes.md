# Week 3 Notes

## Part 4: Variables
- **Why do example.tfvars and terraform.tfvars both exist?**
  example.tfvars is a template with fake values committed to Git so teammates know what variables are needed. terraform.tfvars contains the real, sensitive values (like the database password) and is kept only locally.
- **What would go wrong if you committed terraform.tfvars?**
  Our real database password would be uploaded to the public GitHub repository, which is a major security risk.

## Part 5: Network Information
- **My VPC ID:** [PASTE YOUR VPC ID HERE]
- **Number of Subnets found:** [WRITE THE NUMBER HERE]
- **Why I am not hardcoding these values:**
  Because VPC and Subnet IDs are different in every AWS account. Using data sources allows this code to work for anyone in the cohort without changing the code.

## Part 6: The Database
- **Why is the database outside the container now?**
  Containers are disposable. If a container restarts or is deleted, any data inside it is lost. Moving the database to RDS ensures our data is permanent and survives application updates or crashes.
- **Which two settings here are deliberately wrong, and which project fixes them?**
  `backup_retention_period = 0` (no backups) and `skip_final_snapshot = true` (no backup on delete). The "Recover it" project fixes these to ensure data can be restored if something goes wrong.

## Part 7: Roles and Tasks
- **What is the execution role for?**
  It is the role AWS itself uses to pull the Docker image from ECR and write logs to CloudWatch. It is not the role the application code uses.
- **Why is aws_db_instance.tasks.address better than typing the hostname?**
  Because we don't know the database address until Terraform creates it. Using the reference means Terraform automatically knows the task depends on the database and will build them in the right order.
- **What is the security weakness here?**
  The database password is sitting in plaintext inside the task definition and the state file. The "Secure it" project fixes this by using AWS Secrets Manager.

## Part 8: Load Balancer
- **Which single setting here would have saved you time last week?**
  `target_type = "ip"`. In Fargate, tasks are identified by IP addresses, not EC2 instance IDs. If you leave this as the default ("instance"), the health checks will fail and the app won't work.
