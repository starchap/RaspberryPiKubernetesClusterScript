#!/bin/bash
source ./config.sh

if [ "$configuser" == 'true' ]
then

	usedusername=$(whoami)
	if [ "$usedusername" == 'pi' ]
	then
		echo 'You are using the user pi let us change that? (y/n)'
		read confirmation11
		if [ "$confirmation11" == 'y' ]
		then
			echo "Creating new user"
			echo "Enter Username"
			read newusername
			sleep 1
			echo "Adding user $newusername"
			sudo adduser $newusername
			sleep 1
			echo "Adding user privileges to $newusername"
			sudo usermod -a -G adm,dialout,cdrom,sudo,audio,video,plugdev,games,users,input,netdev,gpio,i2c,spi $newusername
			sleep 1
			echo "Please enter a password for $newusername"
			sudo passwd $newusername
			sleep 1
			echo "Clone pi content to new user"
			su root -c "sudo cp /home/pi/FNAME /home/$newusername/FNAME && sudo chown $newusername:$newusername /home/$newusername/FNAME"
			sleep 1
			echo 'Logout and login as new user please..'
			sleep 3
			sudo logout
		fi
	fi
	if [ "$usedusername" != 'pi' ]
	then
		echo "You are logged in as $username do you wanna remove the pi user? (y/n)"
		read confirmation12
		if [ "$confirmation12" == 'y' ]
		then
			echo "Isolating the pi user"
			sudo pkill -u pi
			sleep 1
			echo "getting rid of the body"
			sudo deluser pi
			sleep 1
			echo "getting rid of the pi users home"
			sudo deluser -remove-home pi
			sleep 1
			echo "The pi user is no more"
		fi
		
	fi
fi

if [ "$hostname" != '' ]
then
	echo "Configuring node hostname"
	sudo sed -i "/raspberrypi/$hostname" /etc/hosts
	sudo sed -i "/raspberrypi/$hostname" /etc/hostname
	echo "The Hostname for this node is now $hostname"
fi

if [ "$sshpub" != '' ]
then
	echo "Configuring node public key"
	sudo mkdir ./.ssh
	echo $sshpub >> ./.ssh/authorized_keys
	sudo chmod 600 ./.ssh/authorized_keys
	sudo chmod 700 .shh
	echo "The public ssh key is now in use"
fi

if [ "$preventpass" != 'false' ]
then
	echo "Configuring node to login only using public key"
	sudo sed -i "/PasswordAuthentication/c\PasswordAuthentication no" /etc/ssh/sshd_config
	echo "Use the private ssh key to access $(echo )"
fi

if [ "$staticip" != '' ]
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


if [ "$ismasternode" == 'true' ]
then
	echo "The node will become a master node"
	curl -sfL https://get.k3s.io | sh - 
	echo "Connect your nodes using the following token"
	sudo cat /var/lib/rancher/k3s/server/node-token
elif [ "$ismasternode" == 'false' ] && [ "$masternodetoken" != '' ] && [ "$masternodetoken" != '' ]
then
	echo "The node will become a worker node"
	echo "NOTE: The Worker label must be assigned from the master node using"
	echo "kubectl label node $nodename node-role.kubernetes.io/worker=worker"
	curl -sfL http://get.k3s.io | K3S_URL=https://$masternodeip:6443 K3S_TOKEN=$masternodetoken sh -
fi

echo 'All configured are you ready to reboot your pi? (y/n)'
read confirmation2
if [ "$confirmation2" == 'y' ]
then
	sudo reboot
fi
