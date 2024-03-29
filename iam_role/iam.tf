variable "name" {}
variable "policy"{}
variable "identifier"{}

resource "aws_iam_role" "default" {
  name = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "default" {
  name = var.name
  policy = var.policy
}

resource "aws_iam_role_policy_attachment" "default" {
  role = aws_iam_role.default.name
  policy_arn = aws_iam_policy.default.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [var.identifier]
    }
  }
}

# out put用の記述。削除可
output "output_aws_iam_policy" {
  value = aws_iam_role.default.arn
}

output "output_iam_role_name" {
  value = aws_iam_role.default.name
}

output "aws_iam_policy_arn" {
  value = aws_iam_policy.default.arn
}

output "aws_iam_policy" {
  value = aws_iam_role.default.name
}