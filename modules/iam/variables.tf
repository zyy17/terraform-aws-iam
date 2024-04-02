variable "groups" {
  description = "A list of group objects including name, policy_arn, and additional policies"
  type = list(object({
    # The name of the group.
    name = string

    # The existing policy ARN to attach to the group.
    policy_arns = optional(list(string))

    # The file path to the additional policy JSON to attach to the group.
    # TODO(zyy17): can we use list(string) here? For example, if we want to attach multiple policies to a group.
    additional_policy_json = optional(string)
  }))
  default = []
}

variable "users" {
  description = "A list of user objects including name, group, policy_arn, and additional policies"
  type = list(object({
    # The name of the user.
    name = string

    # The name of the group to which the user belongs.
    groups = optional(list(string))

    # The existing policy ARN to attach to the user.
    # TODO(zyy17): can we use list(string) here?
    policy_arn = optional(string)

    # The file path to the additional policy JSON to attach to the user.
    # TODO(zyy17): can we use list(string) here?
    additional_policy_json = optional(string)
  }))
  default = []
}
