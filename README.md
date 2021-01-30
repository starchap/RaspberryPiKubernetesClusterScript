# Raspberry pi Kubernetes Cluster Script
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

Lastly execute the kube.sh script

```console
sudo ./kube.sh
```
