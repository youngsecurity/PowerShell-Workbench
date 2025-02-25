$HostNames = Get-Content ".\hostnames.txt"

try {
    ForEach ($HostName in $HostNames) {     
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential) -ConfigurationName PowerShell.7.4.0
        Invoke-Command -Session $PSSession -ScriptBlock { # some code            
            Write-Host `r
            Write-Host "hostname:" (hostname)

            Write-Host "whoami:" (whoami)                       
            
            # List apps with available upgrades
            #winget upgrade --accept-source-agreements --include-unknown
            
            # Upgrade all installed apps
            #winget upgrade --accept-source-agreements --include-unknown --all
            
            # Upgrade individual apps
            winget upgrade --id SlackTechnologies.Slack                        
            winget upgrade --id Microsoft.PowerToys
            winget upgrade --id Bitwarden.Bitwarden
            winget upgrade --id SideQuestVR.SideQuest
            winget upgrade --id Microsoft.VisualStudio.2019.Community
            winget upgrade --id Google.AndroidStudio
            winget upgrade --id GeoGebra.CalculatorSuite
            winget upgrade --id GnuPG.GnuPG
            winget upgrade --id GnuPG.Gpg4win
            winget upgrade --id Notepad++.Notepad++
            winget upgrade --id OBSProject.OBSStudio
            winget upgrade --id Spotify.Spotify
            winget upgrade --id Stride.Stride
            winget upgrade --id JAMSoftware.TreeSize.Free
            winget upgrade --id WiresharkFoundation.Wireshark
            winget upgrade --id JeffreyPfau.mGBA
            winget upgrade --id Microsoft.VCRedist.2013.x64
            winget upgrade --id Keybase.Keybase
            winget upgrade --id Hashicorp.Vagrant            
            winget upgrade --id Oracle.JavaRuntimeEnvironment
            winget upgrade --id clsid2.mpc-hc
            winget upgrade --id Bethesda.Launcher
            winget upgrade --id Microsoft.VCRedist.2015+.x64
            winget upgrade --id Microsoft.VCRedist.2015+.x86
            winget upgrade --id Microsoft.WindowsSDK
            winget upgrade --id TheDocumentFoundation.LibreOffice
            winget upgrade --id Chocolatey.ChocolateyGUI
            winget upgrade --id Mojang.MinecraftLauncher
            winget upgrade --id MoonlightGameStreamingProject.Moonlight
            winget upgrade --id calibre.calibre
            winget upgrade --id Microsoft.PowerShell
            winget upgrade --id VirtualDesktop.Streamer
            winget upgrade --id EpicGames.EpicGamesLauncher
            winget upgrade --id Unity.UnityHub
            winget upgrade --id dokan-dev.Dokany
            winget upgrade --id Microsoft.DotNet.Runtime.3_1
            winget upgrade --id Grammarly.ForOffice
            winget upgrade --id Microsoft.VCRedist.2013.x86
            winget upgrade --id Docker.DockerDesktop
            winget upgrade --id Mozilla.Firefox
            winget upgrade --id JAMSoftware.TreeSize.Free
            winget upgrade --id VideoLAN.VLC
            winget upgrade --id Google.Chrome
            winget upgrade --id Splashtop.SplashtopPersonal

            # Do not upgrade these apps
            #RoyalApps.RoyalTS

            # Install apps if they are not already installed
            #winget install -e --silent --accept-source-agreements --accept-package-agreements --id clsid2.mpc-hc
            
        } -ErrorAction Continue # Error handling

            Write-Host "whoami:" (whoami)
                        
            #winget upgrade --accept-source-agreements --include-unknown
            #winget upgrade --accept-source-agreements --accept-package-agreements --id SlackTechnologies.Slack
            #winget upgrade --accept-source-agreements --accept-package-agreements --id Notepad++.Notepad++
            winget upgrade --accept-source-agreements --accept-package-agreements --id MoonlightGameStreamingProject.Moonlight
            
            # Do not upgrade these apps
            #RoyalApps.RoyalTS
            #winget install -e --silent --accept-source-agreements --accept-package-agreements --id clsid2.mpc-hc
            
    } -ErrorAction Stop # Error handling
}    
catch {    
    Write-Host "An Error Occured" -ForegroundColor Red
    Write-Host $PSItem.Exception.Message -ForegroundColor Red
}
finally {
    Write-Host `r`n
    $Error.Clear()
    Remove-PSSession -Session $PSSession
}
