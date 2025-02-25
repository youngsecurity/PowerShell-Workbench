# Install Media Player(s) 
Set-Location -Path 'C:\Users\Public\Downloads'
Invoke-WebRequest -Uri "https://github.com/mpc-hc/mpc-hc/releases/download/1.7.13/MPC-HC.1.7.13.x64.exe" -OutFile ".\MPC-HC.1.7.13.x64.exe"
Start-Process -FilePath ".\MPC-HC.1.7.13.x64.exe" -Verb runAs -ArgumentList '/SP','/VERYSILENT','/NORESTART'