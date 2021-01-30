# Raspberry pi Kubernetes Cluster Script
Setting up your raspberry pi's to run kubernetes can take some time, the goal of this repo is to shorten that time with a simple script

Simply run the following commands from each of your pi's

```console
sudo curl -LO https://raw.githubusercontent.com/starchap/RaspberryPiKubernetesClusterScript/master/kube.sh
```

```console
sudo curl -LO https://raw.githubusercontent.com/starchap/RaspberryPiKubernetesClusterScript/master/config.sh
```

Edit your configuration for your pi.

```console
sudo nano config.sh
```

Enable the kube script by entering the following

```console
sudo chmode +x ./kube.sh
```

Lastly execute the kube.sh script, (There are curretly still bugs in the script, however please point them out if you know the solution)

```console
sudo ./kube.sh
```
