variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "node_group_name" {
  description = "EKS node group name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the node group"
  type        = list(string)
}

variable "instance_types" {
  description = "EC2 instance types for the node group"
  type        = list(string)

  default = ["t3.small"]
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number

  default = 2
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number

  default = 1
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number

  default = 3
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number

  default = 20
}
