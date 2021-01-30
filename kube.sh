#!/bin/bash
source ./config.sh

if [ $configuser == "true" ]
then
	echo 'It is recomended to change the user pi username and password wanna configure it now? (y/n)'
	read confirmation1
	if [ $confirmation1 == 'y' ]
	then
		echo 'Please enter new username'
		su root -c "read loginname"
		echo "Setting up new account login name as: $loginname"
		su root -c "usermod -l $loginname -d /home/$loginname -m pi"
		su root -c "groupmod --new-name $loginname pi"
		echo 'What is your realname?'
		su root -c "read realname"
		su root -c "usermod -c "$realname" $loginname"
		echo "Now to set new password for $realname aka $loginname"
		su root -c "passwd $loginname"
		echo "all done please reboot and login as $loginname"
		echo 'locking root account'
		su root -c "passwd -l root"
		echo 'now logging out in:'
		sudo logout
	fi
fi

if [ $hostname != "" ]
then
	echo "Configuring node hostname"
	sudo sed -i "/raspberrypi/$hostname" /etc/hosts
	sudo sed -i "/raspberrypi/$hostname" /etc/hostname
	echo "The Hostname for this node is now $hostname"
fi

if [ "$sshpub" != "" ]
then
	echo "Configuring node public key"
	sudo mkdir ./.ssh
	echo $sshpub >> ./.ssh/authorized_keys
	sudo chmod 600 ./.ssh/authorized_keys
	sudo chmod 700 .shh
	echo "The public ssh key is now in use"
fi

if [ $preventpass != "false" ]
then
	echo "Configuring node to login only using public key"
	sudo sed -i "/PasswordAuthentication/c\PasswordAuthentication no" /etc/ssh/sshd_config
	echo "Use the private ssh key to access $(echo )"
fi

if [ $staticip != "" ]
then
	echo "Configuring node static IP address"
	ethernet=$(ip r | awk '/default/ { print $5 }')
	gateway=$(ip r | awk '/default/ { print $3 }')
	domainservers=$(sudo grep 'nameserver' /etc/resolv.conf | awk '/nameserver/ {print $2}' | tr -d '\n')
	echo "interface $(echo $ethernet)" >> /etc/dhcpcd.conf
	echo "static ip_address=$staticip/24" >> /etc/dhcpcd.conf
	echo "static routers=$gateway" >> /etc/dhcpcd.conf
	echo "static domain_name_servers=$domainservers" >> /etc/dhcpcd.conf
	echo "The node now has a static IP address $staticip"
fi


if [ $ismasternode == "true" ]
then
	echo "The node will become a master node"
	curl -sfL https://get.k3s.io | sh - 
	echo "Connect your nodes using the following token"
	sudo cat /var/lib/rancher/k3s/server/node-token
else if [ $ismasternode == "false" && $masternodetoken != "" && $masternodetoken != "" ]
then
	echo "The node will become a worker node"
	echo "NOTE: The Worker label must be assigned from the master node using"
	echo "kubectl label node $nodename node-role.kubernetes.io/worker=worker"
	curl -sfL http://get.k3s.io | K3S_URL=https://$masternodeip:6443 K3S_TOKEN=$masternodetoken sh -
fi

echo 'All configured are you ready to reboot your pi? (y/n)'
read confirmation2
if [ $confirmation2 == 'y' ]
then
	sudo reboot
fi
