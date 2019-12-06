output "UserPoolId" {
  value       = "${aws_cognito_user_pool.sba-userPool-test.id}"
  description = "The id of aws cognito user pool."

  depends_on = [
    "${aws_cognito_user_pool.sba-userPool-test}",
  ]
   sensitive   = true
}


output "UserPoolClientId" {
  value       = "${aws_cognito_user_pool_client.sba-user-pool-client.id}"
  description = "The id of aws cognito user pool client."

  depends_on = [
    "${aws_cognito_user_pool_client.sba-user-pool-client}",
  ]
   sensitive   = true
}


output "IdentityPoolId" {
  value       = "${aws_cognito_identity_pool.IdentityPool.id}"
  description = "The id of aws cognito identity pool."

  depends_on = [
     "${aws_cognito_identity_pool.IdentityPool}",
  ]
    sensitive   = true
}