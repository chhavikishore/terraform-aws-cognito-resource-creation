# change IdentityPool name accordingly to development environment everywhere 
# put your own access key and secret key
# put provider_name in aws_cognito_identity_pool 


# AWS provider   

provider "aws" {
  region     = "ap-south-1"
  access_key = "root"
  secret_key = "root"
}



# AWS cognito user pool

resource "aws_cognito_user_pool" "sba-userPool-test" {
  name = "sba-userPool-test"
  mfa_configuration = "OFF"
  password_policy {
      minimum_length    = 6
      require_lowercase = false
      require_numbers   = true
      require_symbols   = false
      require_uppercase = true
  }
}



# AWS cognito user pool client

resource "aws_cognito_user_pool_client" "sba-user-pool-client" {
  name = "sba-user-pool-client"

  user_pool_id        = "${aws_cognito_user_pool.sba-userPool-test.id}"
  generate_secret     = false
}



# AWS cognito identity pool

resource "aws_cognito_identity_pool" "IdentityPool" {
  identity_pool_name               = "IdentityPool"
  allow_unauthenticated_identities = false

  # cognito_identity_providers {
  #   client_id               = "${aws_cognito_user_pool_client.sba-user-pool-client.id}"
  # }
}



# AWS cognito identity pool role attachment

resource "aws_cognito_identity_pool_roles_attachment" "main" {
  identity_pool_id = "${aws_cognito_identity_pool.IdentityPool.id}"

  roles = {
    "authenticated" = "${aws_iam_role.authenticated.arn}"
  }
}



# AWS IAM role

resource "aws_iam_role" "authenticated" {
  name = "cognito_authenticated"

  assume_role_policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.IdentityPool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}


# AWS IAM role policy

resource "aws_iam_role_policy" "authenticated" {
  name = "CognitoAuthorizedPolicy"
  role = "${aws_iam_role.authenticated.id}"

  policy = <<EOF
{
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*",
        "s3:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}
