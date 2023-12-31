#!/bin/bash

################################################################################
# Script Name: Get-PowerShell.sh
# Description: This script will install PowerShell 7+ on Ubuntu.
# Author: Joseph Young <joe@youngsecurity.net>
# Created: 2023/12/30
# Version: 1.0
################################################################################

# Exit immediately if a command exits with a non-zero status
#set -e

# Define variables
#VAR1="value1"
#VAR2="value2"

# Define functions
function install_pwsh() {    
    ###################################
    # Prerequisites

    # Update the list of packages
    sudo apt-get update

    # Install pre-requisite packages.
    sudo apt-get install -y wget

    # Download the PowerShell package file
    wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.0/powershell_7.4.0-1.deb_amd64.deb

    ###################################
    # Install the PowerShell package
    sudo dpkg -i powershell_7.4.0-1.deb_amd64.deb

    # Resolve missing dependencies and finish the install (if necessary)
    sudo apt-get install -f

    # Delete the downloaded package file
    rm powershell_7.4.0-1.deb_amd64.deb

    # Start PowerShell Preview
    pwsh-lts
    }

# Main code
# Notify the user the script has started.
echo "Starting the script!"

# Call a function
install_pwsh

# Do some other things...
#echo "Variable 1 is: $VAR1"
#echo "Variable 2 is: $VAR2"

# Notify the user the script has completed.
echo "Script has finished!"