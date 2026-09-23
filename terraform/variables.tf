variable "rg-ansible-adhoc-lab" {
  description = "Description of the resource group for the Ansible Adhoc Lab"
  type        = string
  default     = "rg-ansible-adhoc-lab"
}

variable "vnet-ansible-adhoc-lab" {
  description = "Description of the virtual network for the Ansible Adhoc Lab"
  type        = string
  default     = "vnet-ansible-adhoc-lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the virtual network"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet-ansible-adhoc-lab" {
  description = "Description of the subnet for the Ansible Adhoc Lab"
  type        = string
  default     = "subnet-ansible-adhoc-lab"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "igw-ansible-adhoc-lab" {
  description = "Description of the internet gateway for the Ansible Adhoc Lab"
  type        = string
  default     = "igw-ansible-adhoc-lab"
}

variable "rt-ansible-adhoc-lab" {
  description = "Description of the route table for the Ansible Adhoc Lab"
  type        = string
  default     = "rt-ansible-adhoc-lab"
}

variable "ansiblemm" {
  description = "Description of the network security group for the Ansible Adhoc Lab"
  type        = string
  default     = "ansiblemm"
}



variable "vm_roles" {
  description = "Description of the virtual machine for the Ansible Adhoc Lab"
  type        = list(string)
  default = ["web1",
    "web2"
  ]
}


variable "ansible-adhoc-key" {
  description = "Path to the public key for SSH access"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}

