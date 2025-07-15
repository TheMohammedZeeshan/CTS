variable "snowflake_account" {
  type    = string
  default = "DTVABHB-AE51151"
}

variable "snowflake_user" {
  type    = string
  default = "reach2zeeshan"
}

variable "snowflake_password" {
  type        = string
  sensitive   = true
  description = "Snowflake password"
}


variable "snowflake_role" {
  type    = string
  default = "ACCOUNTADMIN"
}

variable "snowflake_region" {
  type    = string
  default = "AWS_US_EAST_2"
}
