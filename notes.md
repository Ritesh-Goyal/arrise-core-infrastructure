# DevOps Assessment Notes

This repository contains Terraform work for the five assessment tasks. The notes below describe the current files and call out items that still need completion.

## Tasks 1 and 2: EC2 and remote state

- `task1_n_task2/dev/compute-ec2.tf` drives the instances from one `configuration` input. The current configuration defines three EC2 instances, each with its own instance type, key pair, root volume size and type; one uses `io1` with 100 IOPS. All three receive `Name`, `Environment` and `Owner` tags.
- `dev/terraform-outputs.tf` exposes a map keyed by instance name. Each entry contains the corresponding instance ID and private IP.
- The assessment asks for five instances and a Terraform `prevent_destroy` lifecycle rule for one chosen instance. The current configuration has three instances and no `prevent_destroy` rule. `disable_api_termination` is set for the app instance, but that is an EC2 API setting and does not prevent Terraform from planning its deletion.
- `dev/terraform-backend.tf` configures S3 state storage and a DynamoDB lock table. With local state, two concurrent applies can act on separate state snapshots and produce conflicting or overwritten state. The shared backend and lock serialize Terraform operations against the same state.

## Tasks 3 and 4: IAM and CI permissions

- `task3_n_task4/task3.tf` defines `group1` for `engine` and `ci`, `group2` for the named console users, `roleA` with administrative actions except IAM, `roleB` for cross-account role assumption, and `roleC` with access scoped to the configured artifacts bucket.
- `roleC` trusts the specific `roleB` ARN. Trusting the Account A root would allow Account A administrators to authorize other principals in that account to assume the role; naming `roleB` narrows the trusted principal. The caller still needs `sts:AssumeRole` permission, which is granted to `roleB` in Account A.
- For production, human and workload access should use federation or IAM roles with temporary credentials where possible. Long-lived IAM user access keys increase the risk and operational burden of leaked or stale credentials. AWS recommends temporary credentials for humans and workloads ([IAM security best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)).
- `task3_n_task4/task4.tf` scopes ECR image push and S3 artifact reads to the configured resources and grants ECS describe/update actions. The current policy does not include `ecs:RegisterTaskDefinition` or `iam:PassRole`, so it may not support registering and deploying a new task definition end to end. It deliberately omits broad administrator, IAM, ECR delete, and S3 write permissions.

## Task 5: Assume-role bug

- The trust policy must name an IAM role principal, such as `arn:aws:iam::<account-a-id>:role/roleB`; `...:user/roleB` points to a user that is not the role. Trusting the specific role limits who can assume `roleC`.
- `task5/main.tf` currently has the role ARN in the trust policy, but its permissions policy still grants `s3:*` on `*`. That gives access to every S3 bucket rather than one named bucket. The policy should grant only the required S3 actions on the named bucket and its objects. This second issue is not fixed in the current file.
