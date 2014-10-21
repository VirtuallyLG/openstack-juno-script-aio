Openstack Juno AIO Installation User guide on Ubuntu 14.04

# I. LAB information
- Installing Openstack Juno on Ubuntu 14.04 using vmware-workstation.
- Openstack Elements that are going to be installed: Keystone, Glance, Nova (using KVM), Neutron, Horizon.
- Neutron uses ML2 plugin, GRE and use cases for model network is per-tenant per-router.
- virtual machine uses 2 NICs, Eth0 for External, API, MGNT and Eth1 for Internal.

# II. Steps in installation
## 1. Installing Ubuntu 14.04 within Vmware Workstation

Configurations of Ubuntu Server 14.04 within VMware Workstation or physical machine:
- RAM 4GB
- 1st HDD (sda) 60GB installing Ubuntu server 14.04
- 2nd HDD (sdb): Volume for CINDER
- 3rd HDD (sdc): Using for SWIFT
- NIC 1st : External - Using Bridge mode - IP range: 192.168.1.0/24 - Gateway 192.168.1.1
- NIC 2nd : Inetnal VM - Using vmnet4 mode (Need setting up in VMware Workstation before installing Ubuntu - IP range: 192.168.10.0/24)

| NIC 	       | IP ADDRESS     |  SUBNET MASK  | GATEWAY       | DNS     |                   Note               |
| -------------|----------------|---------------|---------------|-------  |--------------------------------------| 
| NIC 1 (eth0) | 192.168.1.xxx  | 255.255.255.0 | 192.168.1.1   | 8.8.8.8 | Bridge in VMware Workstation      |
| NIC 2 (eth1) | 192.168.10.xxx | 255.255.255.0 |    NULL       |   NULL  | Using VMnet4 in Vmware Workstation |

