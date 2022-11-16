$HostNames = Get-Content "G:\My Drive\!_Work\Notes\PowerShell-Workbench\hostnames.txt"

try {
    ForEach ($HostName in $HostNames) {     
        $PSSession = New-PSSession -ComputerName $HostName #-Credential (Get-Credential)
        Invoke-Command -Session $PSSession -ScriptBlock { # some code            
            Write-Host `r
            Write-Host "hostname:" (hostname)

            Write-Host "whoami:" (whoami)                       
            
            # List apps with available upgrades
            #winget upgrade --accept-source-agreements --include-unknown
            
            # Upgrade all installed apps
            #winget upgrade --accept-source-agreements --include-unknown --all
            
            # Upgrade individual apps
            #winget upgrade --accept-source-agreements --id SlackTechnologies.Slack                        
            #winget upgrade --accept-source-agreements --id Microsoft.PowerToys
            winget upgrade --accept-source-agreements --id Bitwarden.Bitwarden
            winget upgrade --accept-source-agreements --id SideQuestVR.SideQuest
            winget upgrade --accept-source-agreements --id Microsoft.VisualStudio.2019.Community
            winget upgrade --accept-source-agreements --id Google.AndroidStudio
            winget upgrade --accept-source-agreements --id GeoGebra.CalculatorSuite
            winget upgrade --accept-source-agreements --id GnuPG.GnuPG
            winget upgrade --accept-source-agreements --id GnuPG.Gpg4win
            winget upgrade --accept-source-agreements --id Notepad++.Notepad++
            winget upgrade --accept-source-agreements --id OBSProject.OBSStudio
            winget upgrade --accept-source-agreements --id Spotify.Spotify
            winget upgrade --accept-source-agreements --id Stride.Stride
            winget upgrade --accept-source-agreements --id JAMSoftware.TreeSize.Free
            winget upgrade --accept-source-agreements --id WiresharkFoundation.Wireshark
            winget upgrade --accept-source-agreements --id JeffreyPfau.mGBA
            winget upgrade --accept-source-agreements --id Microsoft.VCRedist.2013.x64
            winget upgrade --accept-source-agreements --id Keybase.Keybase
            winget upgrade --accept-source-agreements --id Hashicorp.Vagrant            
            winget upgrade --accept-source-agreements --id Oracle.JavaRuntimeEnvironment
            winget upgrade --accept-source-agreements --id clsid2.mpc-hc
            winget upgrade --accept-source-agreements --id Bethesda.Launcher
            winget upgrade --accept-source-agreements --id Microsoft.VCRedist.2015+.x64
            winget upgrade --accept-source-agreements --id Microsoft.VCRedist.2015+.x86
            winget upgrade --accept-source-agreements --id Microsoft.WindowsSDK
            winget upgrade --accept-source-agreements --id TheDocumentFoundation.LibreOffice
            winget upgrade --accept-source-agreements --id Chocolatey.ChocolateyGUI
            winget upgrade --accept-source-agreements --id Mojang.MinecraftLauncher
            winget upgrade --accept-source-agreements --id MoonlightGameStreamingProject.Moonlight
            winget upgrade --accept-source-agreements --id calibre.calibre
            winget upgrade --accept-source-agreements --id Microsoft.PowerShell
            winget upgrade --accept-source-agreements --id VirtualDesktop.Streamer
            winget upgrade --accept-source-agreements --id EpicGames.EpicGamesLauncher
            winget upgrade --accept-source-agreements --id Unity.UnityHub
            winget upgrade --accept-source-agreements --id dokan-dev.Dokany
            winget upgrade --accept-source-agreements --id Microsoft.DotNet.Runtime.3_1
            winget upgrade --accept-source-agreements --id Grammarly.ForOffice
            winget upgrade --accept-source-agreements --id Microsoft.VCRedist.2013.x86

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
