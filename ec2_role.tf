resource "aws_iam_instance_profile" "web_app_profile" {
  name = "web_app_profile"
  role = aws_iam_role.web_app_role.name
}

resource "aws_iam_role" "web_app_role" {
  name = "web_app_ec2_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create additional policy for ec2 instance to access ecr
resource "aws_iam_policy" "ecr_access_policy" {
  name = "ecr_access_policy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:GetRegistryPolicy",
                "ecr:DescribeImageScanFindings",
                "ecr:GetLifecyclePolicyPreview",
                "ecr:GetDownloadUrlForLayer",
                "ecr:DescribeRegistry",
                "ecr:DescribePullThroughCacheRules",
                "ecr:DescribeImageReplicationStatus",
                "ecr:GetAuthorizationToken",
                "ecr:ListTagsForResource",
                "ecr:ListImages",
                "ecr:BatchGetRepositoryScanningConfiguration",
                "ecr:GetRegistryScanningConfiguration",
                "ecr:UntagResource",
                "ecr:BatchGetImage",
                "ecr:DescribeImages",
                "ecr:TagResource",
                "ecr:DescribeRepositories",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetRepositoryPolicy",
                "ecr:GetLifecyclePolicy"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "web_app_policy" {
  name = "web_app_policy"
  roles      = [aws_iam_role.web_app_role.name]
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}

