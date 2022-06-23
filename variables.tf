variable "environment" {
  type = string
  validation {
    condition     = contains(["nonprod", "prod"], var.environment)
    error_message = "Allowed values: (nonprod, prod)."
  }
  default = "prod"
}

variable "project" {
  type = string
}

variable "app" {
  type = string
}

variable "location" {
  type    = string
  default = "southeastasia"
}

variable "func_location" {
  type    = string
  default = "eastasia"
}

variable "app_settings" {
  type = map(any)
}
