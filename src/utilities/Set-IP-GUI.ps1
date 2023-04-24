#Requires -RunAsAdministrator
<#
Script made by Noxsios
This script displays a GUI for rapidly / easily changing your computer's IP address
WARNING: ONLY RUN THIS SCRIPT ON APPROVED CONFIG LAPTOPS
Last update: Nov 8 2020
#>

# Fonts used in forms, adjust for preference.
$buttonsFont = New-Object System.Drawing.Font("Calibri", 16, [System.Drawing.FontStyle]::Bold)
$textFont = New-Object System.Drawing.Font("Times New Roman", 13, [System.Drawing.FontStyle]::Regular)
$listBoxFont = New-Object System.Drawing.Font("Consolas", 11, [System.Drawing.FontStyle]::Bold)

function ChangeIP {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [System.Windows.Forms.Application]::EnableVisualStyles()

    # Set the size + properties of the form
    $Form = New-Object System.Windows.Forms.Form
    $Form.Width = 730
    $Form.Height = 330
    $Form.Text = "Config Laptop IPs"
    $Form.TopMost = $True
    $Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $Form.Icon = [System.Drawing.SystemIcons]::Information

    # Set the font of the text to be used within the Form
    $Form.Font = $textFont
    $Form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#D1AC00")
    $Form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#303030")
    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $false

    # Make a dropdown menu to hold all the interface names
    $listBoxInterfaces = New-Object System.Windows.Forms.Listbox
    $listBoxInterfaces.Location = New-Object System.Drawing.Point(320, 40)
    $listBoxInterfaces.Size = New-Object System.Drawing.Size(260, 20)
    $listBoxInterfaces.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#303037")
    $listBoxInterfaces.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#D1AC00")
    $listBoxInterfaces.Font = $listBoxFont
    $listBoxInterfaces.Height = 210

    $interfaces_names = (Get-NetIPInterface).InterfaceAlias | Sort-Object -Property Length

    for ($i = 0; $i -lt $interfaces_names.Count; $i++) {
        if ($interfaces_names[$i] -notmatch '^"Bluetooth') {
            [void] $listBoxInterfaces.Items.Add($interfaces_names[$i])
        }
    }

    # Create a label for that dropdown menu
    $label = New-Object System.Windows.Forms.Label
    $label.Location = New-Object System.Drawing.Point(320, 17)
    $label.Size = New-Object System.Drawing.Size(175, 20)
    $label.Font = $listBoxFont
    $label.Text = 'Select an interface:'

    # Create a group that will contain your radio Buttons
    $MyGroupBox = New-Object System.Windows.Forms.GroupBox
    $MyGroupBox.Left = 15
    $MyGroupBox.Top = 15
    $MyGroupBox.size = New-Object System.Drawing.Size(295, 260)
    $MyGroupBox.text = "Choose an IP configuration:"
    $MyGroupBox.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#D1AC00")
    $MyGroupBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#303037")
    $MyGroupBox.Font = $listBoxFont

    # Create the collection of radio Buttons
    $RadioCustom = New-Object System.Windows.Forms.RadioButton
    $RadioCustom.Left = 20
    $RadioCustom.Top = 40
    $RadioCustom.size = New-Object System.Drawing.Size(350, 20)
    $RadioCustom.Checked = $true
    $RadioCustom.Text = "[ Set Custom ]"

    $RadioUser = New-Object System.Windows.Forms.RadioButton
    $RadioUser.Left = 20
    $RadioUser.Top = $RadioCustom.Top + [int]30
    $RadioUser.size = New-Object System.Drawing.Size(350, 20)
    $RadioUser.Text = "[ User Defined ]"

    $RadioDHCP = New-Object System.Windows.Forms.RadioButton
    $RadioDHCP.Left = 20
    $RadioDHCP.Top = $RadioUser.Top + [int]30
    $RadioDHCP.size = New-Object System.Drawing.Size(350, 20)
    $RadioDHCP.Checked = $false
    $RadioDHCP.Text = "[ DHCP ]"

    $RadioRFK = New-Object System.Windows.Forms.RadioButton
    $RadioRFK.Left = 20
    $RadioRFK.Top = $RadioDHCP.Top + [int]30
    $RadioRFK.size = New-Object System.Drawing.Size(350, 20)
    $RadioRFK.Checked = $false
    $RadioRFK.Text = "[ RFK (Default) ]"

    # Add an OK Button
    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Left = [int]$MyGroupBox.Left + [int]580
    $OKButton.Top = [int]$MyGroupBox.Top + [int]135
    $OKButton.Size = New-Object System.Drawing.Size(100, 40)
    $OKButton.Text = 'OK'
    $OKButton.Font = $buttonsFont
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $OKButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("green")
    $OkButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("darkgray")

    # Add a cancel Button
    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Left = [int]$OKButton.Left
    $CancelButton.Top = [int]$OKButton.Top - [int]60
    $CancelButton.Size = New-Object System.Drawing.Size(100, 40)
    $CancelButton.Text = "Cancel"
    $CancelButton.Font = $buttonsFont
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $CancelButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("darkred")
    $CancelButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("darkgray")

    # Add all the Form controls on one line
    $Form.Controls.AddRange(@($MyGroupBox, $OKButton, $CancelButton, $listBoxInterfaces, $label))

    # Add all the GroupBox controls on one line
    $MyGroupBox.Controls.AddRange(@($RadioCustom, $RadioUser , $RadioDHCP, $RadioRFK))

    # Assign the Accept and Cancel options in the Form to the corresponding Buttons
    $Form.AcceptButton = $OKButton
    $Form.CancelButton = $CancelButton

    # Activate the Form
    $Form.Add_Shown( { $Form.Activate() })

    # Get the results from the Button click
    $dialogResult = $Form.ShowDialog()

    # If the OK Button is selected
    if ($dialogResult -eq "OK") { 

        $sel_interface = $listBoxInterfaces.SelectedItem
        
        $wshell = New-Object -ComObject Wscript.Shell -ErrorAction Stop
        if ($null -eq $sel_interface) {  
            $wshell.Popup('User did not select an interface, script will now exit performing no operations.', 10, "QA Check", 16 + 0);
            throw "User did not select an interface to set the IP of. Please try again.";
        }

        # Check the current state of each radio Button and respond accordingly
        if ($RadioCustom.Checked) {
            Set-Custom 
        }
        elseif ($RadioUser.Checked) {
            Set-UserDefined 
        }
        elseif ($RadioDHCP.Checked) {
            Set-DHCP 
        }
        elseif ($RadioRFK.Checked = $true) {
            Set-RFK 
        }
    }
}

function Set-Custom {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [System.Windows.Forms.Application]::EnableVisualStyles()
  
    # Set the size of your Form
    $Form = New-Object System.Windows.Forms.Form
    $Form.Width = 380
    $Form.Height = 225
    $Form.Text = "Set-Custom"
    $Form.TopMost = $True
    $Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $Form.Icon = [System.Drawing.SystemIcons]::Information

    # Set the font of the text to be used within the Form
    $Form.Font = $textFont
    $Form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#D1AC00")
    $Form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#303030")
    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $false

    $textLabel1 = New-Object System.Windows.Forms.Label
    $textLabel1.Left = 25
    $textLabel1.Top = 15
    $textLabel1.Text = "IP address:"
    $textLabel1.Width = 150

    $textLabel2 = New-Object System.Windows.Forms.Label
    $textLabel2.Left = 25
    $textLabel2.Top = 55
    $textLabel2.Text = "Subnet mask:"
    $textLabel2.Width = 150

    $textLabel3 = New-Object System.Windows.Forms.Label
    $textLabel3.Left = 25
    $textLabel3.Top = 95
    $textLabel3.Text = "Default gateway:"
    $textLabel3.Width = 150

    $textBox1 = New-Object System.Windows.Forms.TextBox
    $textBox1.Font = $listBoxFont
    $textBox1.BackColor = [System.Drawing.ColorTranslator]::FromHtml("darkgray")
    $textBox1.Left = 200
    $textBox1.Top = 10
    $textBox1.Width = 130

    # Dropdown Menu for Subnet Mask
    $listBox = New-Object System.Windows.Forms.ComboBox
    $listBox.Location = New-Object System.Drawing.Point(200, 50)
    $listBox.Size = New-Object System.Drawing.Size(150, 20)
    $listBox.Font = $listBoxFont
    $listBox.BackColor = [System.Drawing.ColorTranslator]::FromHtml("lightgray")
    $listBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $listBox.DropDownHeight = 106
    $listBox.Height = 40

    [void] $listBox.Items.Add('255.255.255.254')
    [void] $listBox.Items.Add('255.255.255.252')
    [void] $listBox.Items.Add('255.255.255.248')
    [void] $listBox.Items.Add('255.255.255.240')
    [void] $listBox.Items.Add('255.255.255.224')
    [void] $listBox.Items.Add('255.255.255.192')
    [void] $listBox.Items.Add('255.255.255.128')
    [void] $listBox.Items.Add('255.255.255.0')
    [void] $listBox.Items.Add('255.255.254.0')
    [void] $listBox.Items.Add('255.255.252.0')
    [void] $listBox.Items.Add('255.255.248.0')
    [void] $listBox.Items.Add('255.255.240.0')
    [void] $listBox.Items.Add('255.255.224.0')
    [void] $listBox.Items.Add('255.255.192.0')
    [void] $listBox.Items.Add('255.255.128.0')
    [void] $listBox.Items.Add('255.255.0.0')
    [void] $listBox.Items.Add('255.254.0.0')
    [void] $listBox.Items.Add('255.252.0.0')
    [void] $listBox.Items.Add('255.248.0.0')
    [void] $listBox.Items.Add('255.240.0.0')
    [void] $listBox.Items.Add('255.224.0.0')
    [void] $listBox.Items.Add('255.192.0.0')
    [void] $listBox.Items.Add('255.128.0.0')
    [void] $listBox.Items.Add('255.0.0.0')
    [void] $listBox.Items.Add('254.0.0.0')
    [void] $listBox.Items.Add('252.0.0.0')
    [void] $listBox.Items.Add('248.0.0.0')
    [void] $listBox.Items.Add('240.0.0.0')
    [void] $listBox.Items.Add('224.0.0.0')
    [void] $listBox.Items.Add('192.0.0.0')
    [void] $listBox.Items.Add('128.0.0.0')

    $textBox3 = New-Object System.Windows.Forms.TextBox
    $textBox3.Font = $listBoxFont
    $textBox3.BackColor = [System.Drawing.ColorTranslator]::FromHtml("darkgray")
    $textBox3.Left = 200
    $textBox3.Top = 90
    $textBox3.Width = 130

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Left = 70
    $OKButton.Top = 130
    $OKButton.Size = New-Object System.Drawing.Size(100, 40)
    $OKButton.Text = 'OK'
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $OKButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("green")
    $OkButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("darkgray")

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Left = 185
    $CancelButton.Top = 130
    $CancelButton.Size = New-Object System.Drawing.Size(100, 40)
    $CancelButton.Text = "Cancel"
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $CancelButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("darkred")
    $CancelButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("darkgray")

    $Form.Controls.AddRange(@($OKButton, $CancelButton, $textLabel1, $textLabel2, $textLabel3, $textBox1, $listBox, $textBox3))

    $Form.AcceptButton = $OKButton
    $Form.CancelButton = $CancelButton

    $Form.Add_Shown( { $Form.Activate() })

    $dialogResult = $Form.ShowDialog()

    # If the OK Button is selected
    if ($dialogResult -eq "OK") {
        $selected_item = $listBox.SelectedItem
        $wshell = New-Object -ComObject Wscript.Shell -ErrorAction Stop

        if ($textBox1.Text -eq '' -or $null -eq $listBox.SelectedItem -or $textBox3.Text -eq '') {  
            $wshell.Popup('User provided blank input, script will now exit performing no operations.', 10, "QA Check", 16 + 0);
            throw "Blank input on Set-Custom. Please try again.";
        }

        if ((isValidIPv4 $textBox1.Text) -and (isValidIPv4 $textBox3.Text)) {
            $wshell_message = "Your IP address will be set to " + $textBox1.Text + " .`n" 
            $wshell_message += "Your mask is $selected_item .`n  Your gateway is " + $textBox3.Text + " .`n"
            $wshell_message += [char]187 + " Are you sure? " + [char]171

            $qa_check = $wshell.Popup($wshell_message, 0, "QA Check", 32 + 4)
            if ($qa_check -eq 7) { throw 'USER CANCELLED OPERATIONS' }

            LogChanges $sel_interface $textBox1.Text $selected_item $textBox3.Text
            netsh.exe interface ip set address $sel_interface static $textBox1.Text $selected_item $textBox3.Text 1
        }
        else {
            $wshell.Popup('Please rerun and provide a valid IP/Gateway.', 10, "QA Check", 16 + 0);
            throw 'Invalid IP/Gateway provided in Set-Custom'
        }
    }
}

function Set-UserDefined {
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
    [System.Windows.Forms.Application]::EnableVisualStyles()
  
    $Form = New-Object System.Windows.Forms.Form
    $Form.Width = 600
    $Form.Height = 170
    $form.MaximumSize.Height = 1000
    $Form.Text = "Set-UserDefined"
    $Form.TopMost = $True
    $Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $Form.Icon = [System.Drawing.SystemIcons]::Information

    $Form.Font = $textFont
    $Form.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("#D1AC00")
    $Form.BackColor = [System.Drawing.ColorTranslator]::FromHtml("#303030")
    $Form.FormBorderStyle = 'Fixed3D'
    $Form.MinimizeBox = $False
    $Form.MaximizeBox = $false

    $formLabel = New-Object System.Windows.Forms.Label
    $formLabel.Left = 10
    $formLabel.Top = 10
    $formLabel.Text = "Choose by clicking on the value in the NAME column then click OK:"
    $formLabel.AutoSize = $True

    $listBoxUser = New-Object System.Windows.Forms.Listbox
    $listBoxUser.Location = New-Object System.Drawing.Point(10, 60)
    $listBoxUser.Size = New-Object System.Drawing.Size(185, 20)
    $listBoxUser.Font = $listBoxFont
    $listBoxUser.BackColor = [System.Drawing.Color]::Snow
    $listBoxUser.ForeColor = [System.Drawing.Color]::Black
    #$listBoxUser.HorizontalScrollbar = $True
    $listBoxUser.BorderStyle = 'None'

    $nameLabel = New-Object System.Windows.Forms.Label
    $nameLabel.Location = New-Object System.Drawing.Point(75, ($listBoxUser.Top - [int]25))
    $nameLabel.Text = "NAME"
    $nameLabel.AutoSize = $true
    $nameLabel.BackColor = $listBoxUser.BackColor
    $nameLabel.ForeColor = [System.Drawing.Color]::Black

    $listBoxIP = New-Object System.Windows.Forms.Listbox
    $listBoxIP.Location = New-Object System.Drawing.Point(($listBoxUser.Left + [int]185), $listBoxUser.Top)
    $listBoxIP.Size = New-Object System.Drawing.Size(125, 0)
    $listBoxIP.BackColor = $listBoxUser.BackColor
    $listBoxIP.ForeColor = [System.Drawing.Color]::MidnightBlue
    $listBoxIP.BorderStyle = 'None'
    $listBoxIP.Font = $listBoxFont
    $listBoxIP.SelectionMode = 'None'

    $ipLabel = New-Object System.Windows.Forms.Label
    $ipLabel.Location = New-Object System.Drawing.Point(($nameLabel.Left + [int]160), ($listBoxUser.Top - [int]25))
    $ipLabel.Text = "IP"
    $ipLabel.AutoSize = $true
    $ipLabel.BackColor = $listBoxUser.BackColor
    $ipLabel.ForeColor = $listBoxIP.ForeColor

    $listBoxMask = New-Object System.Windows.Forms.Listbox
    $listBoxMask.Location = New-Object System.Drawing.Point(($listBoxIP.Left + [int]125), $listBoxUser.Top)
    $listBoxMask.Size = New-Object System.Drawing.Size(125, 0)
    $listBoxMask.BackColor = $listBoxUser.BackColor
    $listBoxMask.ForeColor = [System.Drawing.Color]::DarkRed
    $listBoxMask.BorderStyle = 'None'
    $listBoxMask.Font = $listBoxFont
    $listBoxMask.SelectionMode = 'None'

    $maskLabel = New-Object System.Windows.Forms.Label
    $maskLabel.Location = New-Object System.Drawing.Point(($ipLabel.Left + [int]110), ($listBoxUser.Top - [int]25))
    $maskLabel.Text = "MASK"
    $maskLabel.AutoSize = $true
    $maskLabel.BackColor = $listBoxUser.BackColor
    $maskLabel.ForeColor = $listBoxMask.ForeColor

    $listBoxGate = New-Object System.Windows.Forms.Listbox
    $listBoxGate.Location = New-Object System.Drawing.Point(($listBoxMask.Left + [int]125), $listBoxUser.Top)
    $listBoxGate.Size = New-Object System.Drawing.Size(125, 0)
    $listBoxGate.BackColor = $listBoxUser.BackColor
    $listBoxGate.ForeColor = [System.Drawing.Color]::DarkGreen
    $listBoxGate.BorderStyle = 'None'
    $listBoxGate.Font = $listBoxFont
    $listBoxGate.SelectionMode = 'None'

    $gateLabel = New-Object System.Windows.Forms.Label
    $gateLabel.Location = New-Object System.Drawing.Point(($maskLabel.Left + [int]130), ($listBoxUser.Top - [int]25))
    $gateLabel.Text = "GATE"
    $gateLabel.AutoSize = $true
    $gateLabel.BackColor = $listBoxUser.BackColor
    $gateLabel.ForeColor = $listBoxGate.ForeColor

    if ((Test-Path "$PSScriptRoot\User-Defined-Addresses.csv") -eq $true) {
        $user_def_csv = Import-Csv "$PSScriptRoot\User-Defined-Addresses.csv"
    }
    elseif ((Test-Path "$env:USERPROFILE\Desktop\User-Defined-Addresses.csv") -eq $true) {
        $user_def_csv = Import-Csv "$env:USERPROFILE\Desktop\User-Defined-Addresses.csv"
    }
    else {
        $wshell.Popup("User-Defined-Addresses.csv does not exist at script root folder or user desktop. `nCreating example on user desktop.", 10, "No User Defined", 16 + 0);
        "NAME,IP,MASK,GATE,`nSVR-1,192.168.10.10,255.255.255.0,192.168.10.1," | Out-File -Encoding utf8 "$env:USERPROFILE\Desktop\User-Defined-Addresses.csv"
        throw "Created initial User-Defined-Addresses.csv on Desktop"
    }

    for ($i = 0; $i -lt $user_def_csv.Count; $i++) {
        [void] $listBoxUser.Items.Add([char]0187 + $user_def_csv[$i].Name);
        [void] $listBoxIP.Items.Add($user_def_csv[$i].IP);
        [void] $listBoxMask.Items.Add($user_def_csv[$i].Mask);
        [void] $listBoxGate.Items.Add($user_def_csv[$i].Gate);
        $listBoxUser.Height += [int]20
        $listBoxIP.Height += [int]20
        $listBoxMask.Height += [int]20
        $listBoxGate.Height += [int]20
        $Form.Height += [int]20
    }

    if ($listBoxUser.Height -ge [int]50) { $listBoxUser.Height -= [int]20; $Form.Height -= [int]20 }

    $OKButton = New-Object System.Windows.Forms.Button
    $OKButton.Left = 185
    $OKButton.Top = $listBoxUser.Top + $listBoxUser.Height
    $OKButton.Size = New-Object System.Drawing.Size(100, 40)
    $OKButton.Text = 'OK'
    $OKButton.Font = $buttonsFont
    $OKButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $OKButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("green")
    $OkButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("darkgray")

    $CancelButton = New-Object System.Windows.Forms.Button
    $CancelButton.Left = [int]$OKButton.Left + [int]120
    $CancelButton.Top = [int]$OKButton.Top
    $CancelButton.Size = New-Object System.Drawing.Size(100, 40)
    $CancelButton.Text = "Cancel"
    $CancelButton.Font = $buttonsFont
    $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $CancelButton.BackColor = [System.Drawing.ColorTranslator]::FromHtml("darkred")
    $CancelButton.ForeColor = [System.Drawing.ColorTranslator]::FromHtml("darkgray")

    $Form.Controls.AddRange(@($formLabel, $nameLabel, $ipLabel, $maskLabel, $gateLabel, $OKButton, $CancelButton, $listBoxUser, $listBoxIP, $listBoxMask, $listBoxGate))

    $Form.AcceptButton = $OKButton
    $Form.CancelButton = $CancelButton

    $Form.Add_Shown( { $Form.Activate() })

    $dialogResult = $Form.ShowDialog()

    if ($dialogResult -eq 'OK') {
    
        $name_chosen = ($listBoxUser.SelectedItem -replace [char]0187, '')
        $name_index = $user_def_csv.Name.IndexOf($name_chosen)
        $ip_chosen = $user_def_csv[$name_index].IP
        $mask_chosen = $user_def_csv[$name_index].MASK
        $gate_chosen = $user_def_csv[$name_index].GATE

        $wshell = New-Object -ComObject Wscript.Shell -ErrorAction Stop

        if ($null -eq $ip_chosen -or $null -eq $name_chosen -or $null -eq $mask_chosen -or $null -eq $gate_chosen) {  
            $wshell.Popup('User provided blank input, script will now exit performing no operations.', 10, "QA Check", 16 + 0);
            throw "Choice contained a blank or null value, check your CSV file for blanks.";
        }
    
        $wshell_message = "Your IP address will be set to $ip_chosen .`n" 
        $wshell_message += "Your mask is $mask_chosen .`nYour gateway is $gate_chosen.`n"
        $wshell_message += [char]187 + " Are you sure? " + [char]171

        $qa_check = $wshell.Popup($wshell_message, 0, "QA Check", 32 + 4)
        if ($qa_check -eq 7) { throw 'USER CANCELLED OPERATIONS' }
        LogChanges $sel_interface $ip_chosen $mask_chosen $gate_chosen
        netsh.exe interface ip set address $sel_interface static $ip_chosen $mask_chosen $gate_chosen 1
    }
}

function Set-DHCP {
    $logFile = "$env:USERPROFILE\Desktop\Set-IP-GUI-LOG.txt"
    $date = Get-Date -UFormat "%m-%d-%y %R"
    $previousIP = (Get-NetIPAddress | Where-Object InterfaceAlias -eq $sel_interface).IPAddress
    netsh.exe int ip set address name=$sel_interface source=dhcp
    netsh.exe int ip set dnsservers name=$sel_interface source=dhcp
    Start-Sleep 3
    $newIP = (Get-NetIPAddress | Where-Object InterfaceAlias -eq $sel_interface).IPAddress
    $previousIP_Statement = "[ $date ] [ SUCCESS ] $previousIP on $sel_interface was changed to $newIP, via DHCP."
    $previousIP_Statement | Out-File -Append -Encoding utf8 $logFile
}

function Set-RFK {
    LogChanges $sel_interface '169.254.1.2' '255.255.255.0' '169.254.1.1'
    netsh.exe interface ip set address $sel_interface static 169.254.1.2 255.255.255.0 169.254.1.1 1
    Start-Sleep 1
    Start-Process iexplore.exe http://169.254.1.1
}

function LogChanges ($interface, $ip, $mask, $gate) {
    $logFile = "$env:USERPROFILE\Desktop\Set-IP-GUI-LOG.txt"
    $date = Get-Date -UFormat "%m-%d-%y %R"
    $previousIP = (Get-NetIPAddress | Where-Object InterfaceAlias -eq $sel_interface).IPAddress
    $previousIP_Statement = "[ $date ] [ SUCCESS ] $previousIP on $interface was changed to $ip, with a mask of $mask and a gateway of $gate."
    $previousIP_Statement | Out-File -Append -Encoding utf8 $logFile
}

function isValidIPv4 ($ip) {
    $pattern = "^([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])(\.([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])){3}$"
    return $ip -match $pattern
}

# Call the function
try { ChangeIP }
catch {
    $logFile = "$env:USERPROFILE\Desktop\Set-IP-GUI-LOG.txt"
    $date = Get-Date -UFormat "%m-%d-%y %R"
    Write-Host "An error occured"
    $error_statement = "[ $date ] [ ERROR ] Operation failed via Exit Code / Error: $_"
    $error_statement | Out-File -Append -Encoding utf8 $logFile
}