variable "cluster_name" {
  description = "EKS cluster name"
  type = string
}

variable "cluster_version" {
  description = "EKS kubernetes version"
  type = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type = list(string)
}