locals {
  groups = flatten([
    for _, group in var.groups : [
      for _, policy_arn in(group.policy_arns != null ? group.policy_arns : []) : {
        name                   = group.name
        policy_arn             = policy_arn
        additional_policy_json = group.additional_policy_json
      }
    ]
  ])
}

# Create IAM group.
resource "aws_iam_group" "group" {
  for_each = { for group in var.groups : group.name => group }

  name = each.value.name
}

# Attach the existing policy to the group.
resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  for_each = {
    for group in local.groups : "${group.name}-${group.policy_arn}" => group
  }

  group      = each.value.name
  policy_arn = each.value.policy_arn

  depends_on = [
    aws_iam_user.user,
    aws_iam_group.group,
  ]
}

# Create additional policies for groups.
resource "aws_iam_group_policy" "additional_policy" {
  for_each = {
    for group in var.groups : group.name => group if group.additional_policy_json != null && group.additional_policy_json != ""
  }

  name   = "${each.value.name}-group-additional-policy"
  group  = each.value.name
  policy = file(each.value.additional_policy_json)

  depends_on = [
    aws_iam_user.user,
    aws_iam_group.group,
  ]
}

# Create IAM users.
resource "aws_iam_user" "user" {
  for_each = { for u in var.users : u.name => u }

  name = each.value.name
}

# Each user is a member of one or more groups.
resource "aws_iam_user_group_membership" "group_membership" {
  for_each = { for u in var.users : u.name => u }

  user   = each.value.name
  groups = each.value.groups

  depends_on = [
    aws_iam_user.user,
    aws_iam_group.group,
  ]
}

# Attach the existing policy to the user.
resource "aws_iam_user_policy_attachment" "user_policy_attachment" {
  for_each = {
    for user in var.users : user.name => user if user.policy_arn != null && user.policy_arn != ""
  }

  user       = each.value.name
  policy_arn = each.value.policy_arn

  depends_on = [
    aws_iam_user.user,
    aws_iam_group.group,
  ]
}

# Create additional policies for users.
resource "aws_iam_user_policy" "additional_policy" {
  for_each = {
    for user in var.users : user.name => user if user.additional_policy_json != null && user.additional_policy_json != ""
  }

  name   = "${each.value.name}-user-additional-policy"
  user   = each.value.name
  policy = file(each.value.additional_policy_json)

  depends_on = [
    aws_iam_user.user,
    aws_iam_group.group,
  ]
}
