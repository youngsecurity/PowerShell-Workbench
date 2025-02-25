#!/bin/bash

################################################################################
# Script Name: Get-PowerShell.sh
# Description: This script will install PowerShell 7+ on Ubuntu.
# Author: Joseph Young <joe@youngsecurity.net>
# Created: 2024/01/15
# Version: 1.0
# Example: ./Get-PowerShell.sh <URL>
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
    sudo apt-get install -y wget apt-transport-https software-properties-common

    # Get the URL from the command-line argument
    url="$1"

    # Use wget to download the file and fail if wget encountered any errors
    wget "$url" || {
        echo "Error: Unable to download the file from $url"
        exit 1
    }

    echo "Download completed successfully"

    ###################################
    # Install the package and check if dpkg encountered any errors
    sudo dpkg -i "$(basename "$url")" || {
        echo "Error: Unable to install the downloaded package"
        exit 1
    }

    # Resolve missing dependencies and finish the install (if necessary)
    sudo apt-get install -f

    echo "Installation completed successfully"

    # Delete the downloaded package file
    rm "$(basename "$url")"

    # Start PowerShell Preview
    #pwsh-lts
    }

# Main code
# Notify the user the script has started.
echo "Starting the script!"

# Check if a URL is provided as a command-line argument
if [ $# -ne 1 ]; then
    echo "Please provide a URL."
    echo "Usage: $0 <URL>"
    echo "Script has finished!"
    exit 1
fi

# Call a function
install_pwsh "$@"

# Notify the user the script has completed.
echo "Script has finished!"