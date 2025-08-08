variable "company_prefix" {
  type        = string
  description = "Company prefix."
}

variable "company" {
  type        = string
  description = "Company name."
}

variable "project" {
  type        = string
  description = "Project name."
  default     = "CCaaS"
}


variable "buffering_size" {
  description = "Buffer incoming data to the specified size, in MBs, before delivering it to the destination."
  type        = number
  default     = 5
  validation {
    error_message = "Valid values: minimum: 1 MiB, maximum: 128 MiB."
    condition     = var.buffering_size >= 1 && var.buffering_size <= 128
  }
}

variable "buffering_interval" {
  description = "Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination."
  type        = number
  default     = 300
  validation {
    error_message = "Valid Values: Minimum: 0 seconds, maximum: 900 seconds."
    condition     = var.buffering_interval >= 0 && var.buffering_interval <= 900
  }
}

variable "instance_storage_configs" {
  description = "Map of storage configurations for the Connect instance"
  type        = map(any)
  default     = {}
}
variable "region" {
  type        = string
  description = "AWS region."
}

variable "env" {
  type        = string
  description = "Deployment environment."
}

variable "repo_url" {
  type        = string
  description = "Repository URL."
  default     = "https://github.com/CloverHealth/ccaas-terraform-connect.git"
}

variable "account_number" {
  description = "Account Number."
  type        = string
  default     = null
}

variable "role_name" {
  description = "Role name."
  type        = string
  default     = "shared-gitlab-oidc-role"
}


variable "is_primary" {
  type    = bool
  default = false
}