terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.76.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "snowflake" {
  account   = var.snowflake_account
  username  = var.snowflake_user
  password  = var.snowflake_password
  role      = var.snowflake_role
  region    = var.snowflake_region
}
