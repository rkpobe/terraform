provider "vsphere" {
    user = var.vsphere_user
    password = var.vsphere_password
    vsphere_server = var.vsphere_server
    allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
    name = "ha-datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "WD_Slow"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "ha-datacenter"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_file" "rhel_copy" {
  source_datacenter  = "ha-datacenter"
  datacenter         = "ha-datacenter"
  source_datastore   = "WD_Slow"
  datastore          = "WD_Slow"
  source_file        = "/baseimage/baseimage.vmdk"
  destination_file   = "/${var.vmname}/${var.vmname}.vmdk"
  create_directories = true
}


resource "vsphere_virtual_machine" "vm" {
  depends_on       = [vsphere_file.rhel_copy]
  name             = "terraform-test"
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id

  num_cpus = 2
  memory   = 1024
  guest_id = "rhel8_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "${var.vmname}-disk"
    path = "/${var.vmname}/${var.vmname}.vmdk"
    datastore_id = data.vsphere_datastore.datastore.id
    attach = true
  }
}


