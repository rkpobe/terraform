variable "vsphere_user" {
    type = string
    description = "esxi login user"
}

variable "vsphere_password" {
    type = string
    description = "esxi password"
    sensitive = true
}

variable "vsphere_server" {
    type = string
    description = "esxi addresse"
}

variable "vmname"{
    type=string
    description="name of the vm to be created"
    default="terraform-test"
}