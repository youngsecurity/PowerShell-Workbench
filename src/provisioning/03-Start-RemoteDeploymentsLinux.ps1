# Commands used to setup a Linux Ubuntu system

# scp a file from a remote server to the localhost
scp $userName@{$remoteHost}:/home/$userName/Downloads/fileName.txt /home/$userName/Downloads/fileName.txt

# Congfigure static IPv4
# Step 1: Find NIC name
sudo ip a
# Step 2: Create a file named 01-netcfg.yaml in the /etc/netplan folder
sudo vim /etc/netplan/01-netcfg.yaml
# Step 3: Add the following lines to the file, indents are important for YAML
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0: # Edit this line according to your network interface name
      dhcp4: no # This disable DHCP
      addresses:
        - 192.168.1.10/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 8.8.4.4
# Step 4: Save the file and run the following command
sudo netplan apply

