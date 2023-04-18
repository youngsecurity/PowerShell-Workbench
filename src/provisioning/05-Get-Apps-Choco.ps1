# After choco is done installing, add more apps
choco install -y chocolateygui googlechrome lastpass grammarly winrar python3 treesizefree

# Install vscode in a custom directory
# TODO: Prompt the user for the path to install vscode
choco install vscode.install -y --install-arguments="'/DIR=""F:\Program Files\Microsoft VS Code""'" --force

# Install vscode-insiders in a custom directory
# TODO: Prompt the user for the path to install vscode-insiders
choco install vscode-insiders.install -y --install-arguments="'/DIR=""F:\Program Files\Microsoft VS Code Insiders""'" --force