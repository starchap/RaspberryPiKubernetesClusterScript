# Raspberry pi Kubernetes Cluster Script

> :warning: **If you are using it on a already configured Pi**: Be very careful here!
This script is recommended to use on a clean installation of the Raspberry pi OS. Using it on a already configured Pi has not been tested and might cause your already configured Pi's to misbehave.

Setting up your raspberry pi's to run kubernetes can take some time, the goal of this repo is to shorten that time with a simple script

Simply run the following commands from each of your pi's

```console
sudo curl -LO https://raw.githubusercontent.com/starchap/RaspberryPiKubernetesClusterScript/master/kube.sh
```

```console
sudo curl -LO https://raw.githubusercontent.com/starchap/RaspberryPiKubernetesClusterScript/master/config.sh
```

Make the kube.sh script executable

```console
sudo chmod +x ./kube.sh
```

Edit your configuration for your pi.

```console
sudo nano config.sh
```

| Key             | Type                   | Description                                                                                                                 |
|-----------------|------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| hostname        | string                 | Name of the Pi's hostname, used on the network                                                                              |
| sshpub          | string                 | Assign a public key to use over SSH, you can use the private key to login                                                   |
| preventpass     | boolean (true | false) | Prevent ssh login using password, you must use the private key to login                                                     |
| staticip        | string                 | Requested IP on boot                                                                                                        |
| ismasternode    | boolean (true | false) | Configure the Pi as a master node or worker node, in the kubernetes cluster                                                 |
| masternodeip    | string                 | (ismasternode=false) Signs up worker for a master node found on given IP                                                    |
| masternodetoken | string                 | (ismasternode=false) Sign up worker for a master node using TOKEN                                                           |



Lastly execute the kube.sh script and select one of the 3 options.

```console
./kube.sh
```

1. Option adds a new user to the raspberry pi, using this command is a 2 step process you must enter a username and password thereafter login as that user and run the script again with option 1 will enable you to delete the default pi user.

2. Option adds a static IP address, hostname and applies a public key to the ssh connection if any is defined in the config.sh otherwise it skips the configuration of it. note that "preventpass" must be false when you do not use a public key otherwise leave it as true.

3. Option setup's Kubernetes on the raspberry pi, either as a master or a worker, if you are configuring a working it is important to fill the Ip for the master node and the token it has to apply in order to connect.
