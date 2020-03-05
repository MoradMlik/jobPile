data "azurerm_resource_group" "rg"{
    name= "${var.name}"
}

#créer un virtual network
data "azurerm_virtual_network" "PileVnet"{
    name= "${var.name_vnet}"
    resource_group_name= "${var.name}"
}

#créer un subnet
resource "azurerm_subnet" "MySecondSubnet" {
    name= "${var.name_subnet2}"
    resource_group_name= "${var.name}"
    virtual_network_name= "${var.name_vnet}"
    address_prefix= "${var.add_prefix2}"
}

#créer network security group
resource "azurerm_network_security_group" "MySecondnsg" {
    name= "${var.name_nsg2}"
    location= "${var.location}"
    resource_group_name= "${var.name}"
  security_rule {
      name= "SSH"
      priority= 1001
      direction= "Inbound"
      access= "Allow"
      protocol= "TCP"
      source_port_range= "*"
      destination_port_range= "22"
      source_address_prefix= "*"
      destination_address_prefix= "*"
  }
  security_rule {
      name= "HTTP"
      priority= 1002
      direction= "Inbound"
      access= "Allow"
      protocol= "TCP"
      source_port_range= "*"
      destination_port_range= "80"
      source_address_prefix= "*"
      destination_address_prefix= "*"
  }
}

#resource "azurerm_public_ip" "MyFirstPubIp" {
#    name= "${var.name_pubIp1}"
#    location= "${var.location}"
#    resource_group_name= "${var.name}"
#    allocation_method= "${var.allocation_method}"
#}

resource "azurerm_network_interface" "TestNIC" {
    name= "${var.nameNIC3}"
    location= "${var.location}"
    resource_group_name= "${var.name}"
    network_security_group_id= "${azurerm_network_security_group.MySecondnsg.id}"
    ip_configuration {
        name= "${var.nameNICconfig3}"
        subnet_id= "${azurerm_subnet.MySecondSubnet.id}"
        private_ip_address_allocation= "${var.allocation_method}"
#	public_ip_address_id= "${azurerm_public_ip.MyFirstPubIp.id}"
    }
}

resource "azurerm_virtual_machine" "TestVM" {
    name= "${var.nameVM3}"
    location= "${var.location}"
    resource_group_name= "${var.name}"
    network_interface_ids= [ "${azurerm_network_interface.TestNIC.id}" ]
    vm_size= "${var.vmSize2}"

    storage_os_disk {
        name= "testDisk"
        caching= "ReadWrite"
        create_option= "FromImage"
        managed_disk_type= "Standard_LRS"
    }
    storage_image_reference {
        publisher= "OpenLogic"
        offer= "CentOS"
        sku= "7.6"
        version= "latest"
    }
    os_profile {
        computer_name= "${var.computer_name3}"
        admin_username= "morad"
    }
    os_profile_linux_config {
        disable_password_authentication= true
        ssh_keys {
            path= "/home/morad/.ssh/authorized_keys"
            key_data= "${var.keyData}"
        }
    }
}
