## About
This repository contains lab setups using Oracle VirtualBox and Vagrant. It provides a convenient way to set up development environments using these tools.

## Main Function Points
Provides lab setups using Oracle VirtualBox and Vagrant
Allows users to easily set up development environments

## Technology Stack
Oracle VirtualBox 7.0.22
<br/>Vagrant 2.4.1
<br/>Virtual box image used : [CentOS-7-x86_64-Vagrant-2004_01.VirtualBox.box](https://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-2004_01.VirtualBox.box)

## License
This project does not specify a license, so the default copyright laws apply.



## Setup Instructions

### 1. Install Git for Windows
Download and install [Git for Windows](https://github.com/git-for-windows/git/releases/download/v2.47.0.windows.1/Git-2.47.0-64-bit.exe) 

### 2. Clone the Repository
After installing Git, clone the repository using:
```
git clone git@github.com:venkiamd/vagrant.git
```

### 3. Change Directory to vagrant
Navigate to the cloned repository:
```
cd vagrant
```

### 4. Create an Images Directory
Create a directory named images.
```
mkdir images
```
### 5. Download the CentOS 7 VirtualBox Image and keep it in `vagrant\images` directory
Download the [CentOS 7 VirtualBox image](https://cloud.centos.org/centos/7/vagrant/x86_64/images/CentOS-7-x86_64-Vagrant-2004_01.VirtualBox.box)

### 6. Make necessary changes to "Vagrantfile"
Go to `vagrant\kubernetes` directory, and modify the Image file path (Linen0:47) in `Vagrantfile`.

### 7. Spinup the cluster 
Run the command `vagrant up` to spinup the Kubernetes cluster. 


