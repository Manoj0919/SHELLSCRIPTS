#!/bin/bash
set -e  # exit immediately if any command fails
echo "Checking for Java ..."
if command -v java >/dev/null 2>&1; then
    echo "Java is already installed. Java version= ${java -version}"
else
    echo "Java is not istalled. installing java Temurin JDK 21.."
    if [ -f /etc/redhat-release ]; then
        # Amazon linux/ RHEL
        #update all packages on your system using the yum package manager (common on RHEL, CentOS, Amazon Linux).
        sudo yum update -y
        sudo yum install java-21-temurin -y
    elif [ -f /etc/debian_version ]; then
        # Ubuntu / Debian
        sudo apt update -y
        sudo apt install -y teumrin-21-jdk
    else
        echo "Unsupported Os. Please install Java Manually"
        exit 1
    fi
    echo " Java installiation Sucessfully. Java version: ${java -version}"
fi  
if command -v jenkins >/dev/null 2>&1; then
    echo "Jenkins already Insatlled. Jenkinsversion : ${jenkins --version}"
else
    echo " Jenkins Installing.... " 
    if [ -f /etc/redhat-release ]; then
        # Amazon linux / RHEL
        sudo yum install -y jenkins
    elif [ -f /etc/debian_version ]; then
        # For Ubuntu Debian
        sudo apt install -y jenkins
    else
        echo "Unsupported os"
    fi
    echo "Jenkins installiation completed. Jenkins version ${jenkins --version}"
fi
if sudo systemctl is-active --quite jenkins; then
    echo "Jenkins is already running"
else 
    echo "Jenkins is not running. Starting jenkins..."
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    echo "Jenkins started Successfully"
    systemctl status jenkins --no-pager
fi
echo "Restarting jenkins...."
sudo systemctl restart jenkins

echo "waiting for jenkins to restart"
for i in {1..10}; do
    if systemctl staus is-active --quite jenkins; then
        echo "Jenkins restated sucessfully.. Your good to work on Jenkins"
        break
    else
        echo "..still jenkins was restatring. (attempt $i)"
        sleep 3
    fi
done