module "iam" {
  source = "../../modules/iam"

  # Create IAM groups.
  groups = [
    {
      name                   = "admin",
      policy_arn             = "arn:aws:iam::aws:policy/AdministratorAccess"
      additional_policy_json = "additional-policies/groups/admin/policy.json",
    },
    {
      name                   = "dev",
      policy_arn             = ""
      additional_policy_json = "additional-policies/groups/dev/policy.json",
    },
    {
      name                   = "ec2-developer",
      policy_arn             = "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
      additional_policy_json = "",
    }
  ]

  # Create IAM users.
  users = [
    {
      name   = "alice",
      groups = ["dev", "ec2-developer"],
    },
    {
      name   = "bob",
      groups = ["admin"],
    },
  ]
}
