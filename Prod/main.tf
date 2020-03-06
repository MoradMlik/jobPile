resource "azurerm_resource_group" "rg" {
    name= "${var.name}"
    location= "${var.location}"
    tags {
        owner= "${var.owner}"
    }
}
#créer un virtual network
resource "azurerm_virtual_network" "PileVnet" {
    name= "${var.name_vnet}"
    address_space= "${var.add_space}"
    location= "${var.location}"
    resource_group_name= "${var.name}"
}
#créer un subnet
resource "azurerm_subnet" "MyFourthSubnet" {
    name= "${var.name_subnet4}"
    resource_group_name= "${var.name}"
    virtual_network_name= "${var.name_vnet}"
    address_prefix= "${var.add_prefix4}"
}

#créer network security group
resource "azurerm_network_security_group" "MyFourthnsg" {
    name= "${var.name_nsg4}"
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

 resource "azurerm_public_ip" "MySecondPubIp" {
    name= "${var.name_pubIp2}"
    location= "${var.location}"
    resource_group_name= "${var.name}"
    allocation_method= "${var.allocation_method}"
    domain_name_label= "prod-om"
 }

resource "azurerm_network_interface" "ProdNIC" {
    name= "${var.nameNIC6}"
    location= "${var.location}"
    resource_group_name= "${var.name}"
    network_security_group_id= "${azurerm_network_security_group.MyFourthnsg.id}"
    ip_configuration {
        name= "${var.nameNICconfig6}"
        subnet_id= "${azurerm_subnet.MyFourthSubnet.id}"
        private_ip_address_allocation= "${var.allocation_method}"
        public_ip_address_id= "${azurerm_public_ip.MySecondPubIp.id}"
    }
}

resource "azurerm_virtual_machine" "ProdVM" {
    name= "${var.nameVM6}"
    location= "${var.location}"
    resource_group_name= "${var.name}"
    network_interface_ids= [ "${azurerm_network_interface.ProdNIC.id}" ]
    vm_size= "${var.vmSize4}"

    storage_os_disk {
        name= "prodDisk"
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
        computer_name= "${var.computer_name6}"
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
