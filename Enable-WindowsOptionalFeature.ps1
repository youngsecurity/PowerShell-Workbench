# Enable Hyper-V using PowerShell and Windows Client OS Programs and Features, this command is not supported on Server
# Future use case: Check OS client|server and proceed if client, if not perform command for Windows Server
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
