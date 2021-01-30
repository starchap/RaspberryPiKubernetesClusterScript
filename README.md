# Raspberry pi Kubernetes Cluster Script

> :disclaimer: **If you are using it on a already configured Pi**: Be very careful here!
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
| configuser      | boolean (true | false) | whether to configure a new user, setting this to true will enable the creation of a new user and remove the default pi user |
| nodename        | string                 | Name of your node on the kubernetes cluster                                                                                 |
| hostname        | string                 | Name of the Pi's hostname, used on the network                                                                              |
| sshpub          | string                 | Assign a public key to use over SSH, you can use the private key to login                                                   |
| preventpass     | boolean (true | false) | Prevent ssh login using password, you must use the private key to login                                                     |
| staticip        | string                 | Requested IP on boot                                                                                                        |
| ismasternode    | boolean (true | false) | Configure the Pi as a master node or worker node, in the kubernetes cluster                                                 |
| masternodeip    | string                 | (ismasternode=false) Signs up worker for a master node found on given IP                                                    |
| masternodetoken | string                 | (ismasternode=false) Sign up worker for a master node using TOKEN                                                           |


Lastly execute the kube.sh script

```console
sudo ./kube.sh
```
