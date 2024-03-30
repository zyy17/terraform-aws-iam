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
  ]

  # Create IAM users.
  users = [
    {
      name                   = "alice",
      group                  = "dev",
      policy_arn             = ""
      additional_policy_json = "additional-policies/users/alice/policy.json",
    },
    {
      name                   = "bob",
      group                  = "admin",
      policy_arn             = "arn:aws:iam::aws:policy/AmazonAppFlowFullAccess"
      additional_policy_json = "additional-policies/users/bob/policy.json",
    },
  ]
}
