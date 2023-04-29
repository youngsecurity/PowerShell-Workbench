# After choco is done installing, add more apps
choco install -y chocolateygui #googlechrome lastpass grammarly winrar treesizefree

# Install vscode in a custom directory
$installPathVSC = Read-Host "Enter the path to install VSCode"
choco install vscode.install -y --install-arguments="'/DIR=""$installPathVSC""'" --force

# Install vscode-insiders in a custom directory
$installPathInsiders = Read-Host "Enter the path to install VSCode Insiders"
choco install vscode-insiders.install -y --install-arguments="'/DIR=""$installPathInsiders""'" --force