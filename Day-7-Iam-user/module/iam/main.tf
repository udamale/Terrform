resource "aws_iam_user" "user" {
  name = var.user_name
}

data "aws_iam_policy_document" "policy_doc" {
  statement {
    effect    = "Allow"
    actions   = var.policy_actions
    resources = var.policy_resources
  }
}

resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  description = "Generated for user ${var.user_name}"
  policy      = data.aws_iam_policy_document.policy_doc.json
}

resource "aws_iam_user_policy_attachment" "attach" {
  user       = aws_iam_user.user.name
  policy_arn = aws_iam_policy.policy.arn
}
