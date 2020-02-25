#!/bin/bash
#V A add in chmod scratch_gpio.sh
#Version B � go back to installing deb gpio package directly
#Version C � install sb files into /home/pi/Documents/Scratch Projects
#Version D � create �/home/pi/Documents/Scratch Projects� if it doesn�t exist
#Version E � change permissions on �/home/pi/Documents/Scratch Projects�
#Version F 13Oct12 � rem out rpi.gpio as now included in Raspbian
#Version G 20Mar13 - Allow otheruser option on commandline (Tnever/meltwater)
#Version H 24Mar13 - correct newline issues
#Version 29Oct13 Add in Chown commands and extra Adafruit and servod files and alter gpio_scrath2.sh and bit of chmod +x make V3
#Version 21Nov13 Change for ScratchGPIO V4
#Version 26Dec13 Change for ScratchGPIO4plus
#Version 18Dec13 Change for ScratchGPIO5
#Version 4Aug14 - change for ScratchGPIO5
#Version 17Sep15 debug creating old scratchgpio icons

SGHVER=$(<SGHVER.txt)
f_exit(){
echo ""
echo "Usage:"
echo "i.e. sudo NameOfInstaller.sh"
# echo "Optional: Add a non-default 'otheruser' username after the command (default is:pi)."
exit
}
echo "Debug Info"

#echo $SUDO_USER

echo "Running Installer"
RDIR="/opt"
HDIR="$RDIR/scratchgpio${SGHVER}/defaultproject"
ICONS="/usr/share/applications"
RUSERID="root"
RGROUPID="root"

#Confirm if install should continue with default PI user or inform about commandline option.
echo ""
echo "Install Details:"
echo "Default project Directory: "$HDIR
echo "User: "$USERID
echo "Group: "$USERID
echo ""

#echo "Is the above Home directory and User/Group correct (1/2)?"
#select yn in "Continue" "Cancel"; do
#    case $yn in
#        Continue ) break;;
#        Cancel ) f_exit;;
#    esac
#done

echo "Please wait a few seconds"
pkill -f servod
sleep 1

echo "Thank you"
rm -rf $RDIR/scratchgpio${SGHVER}

mkdir -p $RDIR/scratchgpio${SGHVER}
mkdir -p $RDIR/scratchgpio${SGHVER}/mcpi
mkdir -p $HDIR

#chown -R $RUSERID:$RGROUPID $HDIR/scratchgpio${SGHVER}

cp scratchgpio_handler8.py $RDIR/scratchgpio${SGHVER}
cp Adafruit_I2C.py $RDIR/scratchgpio${SGHVER}
cp sgh_servod $RDIR/scratchgpio${SGHVER}
cp killsgh.sh $RDIR/scratchgpio${SGHVER}
cp nunchuck.py $RDIR/scratchgpio${SGHVER}
cp meArm.py $RDIR/scratchgpio${SGHVER}
cp kinematics.py $RDIR/scratchgpio${SGHVER}
cp piconzero.py $RDIR/scratchgpio${SGHVER}
cp sgh_*.py $RDIR/scratchgpio${SGHVER}

cp ./mcpi/* $RDIR/scratchgpio${SGHVER}/mcpi

#chown -R $USERID:$GROUPID $RDIR/scratchgpio${SGHVER}
chmod +x sgh_servod
chmod +x killsgh.sh


#Instead of copying the scratchgpioX.sh file, we will generate it
#Create a new file for scratchgpioX.sh
echo "#!/bin/bash" > $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "#Version 0.2 - add in & to allow simultaneous running of handler and Scratch" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "#Version 0.3 - change sp launches rsc.sb from \"/home/pi/Documents/Scratch Projects\"" >>$RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "#Version 0.4 - 20Mar13 meltwater - change to use provided name for home" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "#Version 1.0 - 29Oct13 sw - change to cd into simplesi_scratch_handler to run servods OK" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh

echo "if [ ! -f \"\$HOME/Documents/Scratch Projects/pibrella.sb\" ]" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "then" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "   if [ ! -d \"\$HOME/Documents\" ]" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "     then" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "       mkdir \"\$HOME/Documents\"" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "       chmod 0755 \"\$HOME/Documents\"" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "   fi" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "   if [ ! -d \"\$HOME/Documents/Scratch Projects\" ]" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "     then" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "       mkdir \"\$HOME/Documents/Scratch Projects\"" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "       chmod 0755 \"\$HOME/Documents/Scratch Projects\"" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "   fi" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "   cp -r $HDIR/* \"\$HOME/Documents/Scratch Projects\"" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "   chmod 0755 \"\$HOME/Documents/Scratch Projects/*\"" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "fi" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh

echo "pkill -f scratchgpio_handler" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "cd $RDIR/scratchgpio"$SGHVER >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "python scratchgpio_handler8.py 127.0.0.1 standard &" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "## Give the new gpio handler five seconds to get started fully."  >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "sleep 5"  >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "## The double ampersand and all that follows it pkills the user's scratchgpio_handler after Scratch exits." >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh
echo "scratch --document \"\$HOME/Documents/Scratch Projects/pibrella.sb\" && pkill -f scratchgpio_handler" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh

chmod +x $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}.sh

#Create new desktop icon
echo "[Desktop Entry]" > $ICONS/scratchgpio${SGHVER}.desktop
echo "Encoding=UTF-8" >> $ICONS/scratchgpio${SGHVER}.desktop
echo "Version=1.0" >> $ICONS/scratchgpio${SGHVER}.desktop
echo "Type=Application" >> $ICONS/scratchgpio${SGHVER}.desktop
echo "Exec="$RDIR"/scratchgpio"$SGHVER"/scratchgpio"$SGHVER".sh" >> $ICONS/scratchgpio${SGHVER}.desktop
echo "Icon=scratch" >> $ICONS/scratchgpio${SGHVER}.desktop
echo "Terminal=false" >> $ICONS/scratchgpio${SGHVER}.desktop
echo "Name=ScratchGPIO "$SGHVER >> $ICONS/scratchgpio${SGHVER}.desktop
echo "Comment= Programming system and content development tool" >> $ICONS/scratchgpio${SGHVER}.desktop
echo "Categories=Application;Education;Development;ComputerScience;" >> $ICONS/scratchgpio${SGHVER}.desktop
echo "MimeType=application/x-scratch-project" >> $ICONS/scratchgpio${SGHVER}.desktop

chown $USERID:$GROUPID $ICONS/scratchgpio${SGHVER}.desktop


# #Instead of copying the scratchgpioXplus.sh file, we will generate it
# #Create a new file for scratchgpioXplus.sh
# echo "#!/bin/bash" > $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# echo "#Version 0.2 - add in & to allow simulatenous running of handler and Scratch" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# echo "#Version 0.3 - change sp launches rsc.sb from \"/home/pi/Documents/Scratch Projects\"" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# echo "#Version 0.4 - 20Mar13 meltwater - change to use provided name for home" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# echo "#Version 1.0 - 29Oct13 sw - change to cd into simplesi_scratch_handler to run servods OK" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# echo "pkill -f scratchgpio_handler" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# echo "cd $RDIR/scratchgpio"$SGHVER >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# echo "python scratchgpio_handler8.py &" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# echo "scratch --document \"$HDIR/Documents/Scratch Projects/rsc.sb\" &" >> $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
#
# chmod +x $RDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
# #chown -R $USERID:$GROUPID $HDIR/scratchgpio${SGHVER}/scratchgpio${SGHVER}plus.sh
#
# #Create new desktop icon for plus version
# echo "[Desktop Entry]" > $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Encoding=UTF-8" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Version=1.0" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Type=Application" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Exec="$RDIR"/scratchgpio"$SGHVER"/scratchgpio"$SGHVER"plus.sh" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Icon=scratch" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Terminal=false" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Name=ScratchGPIO "$SGHVER"plus" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Comment= Programming system and content development tool" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "Categories=Application;Education;Development;" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
# echo "MimeType=application/x-scratch-project" >>  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
#
# chown -R $USERID:$GROUPID  $HDIR/Desktop/scratchgpio${SGHVER}plus.desktop
#
# mkdir -p $HDIR/Desktop/ScratchGPIO\ Extras
# chown -R $USERID:$GROUPID $HDIR/Desktop/ScratchGPIO\ Extras
#
#
# #Create a new file for oldscratchgpioX.sh
# echo "#!/bin/bash" > $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
# echo "#Version 0.2 - add in & to allow simultaneous running of handler and Scratch" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
# echo "#Version 0.3 - change sp launches rsc.sb from \"/home/pi/Documents/Scratch Projects\"" >>$RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
# echo "#Version 0.4 - 20Mar13 meltwater - change to use provided name for home" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
# echo "#Version 1.0 - 29Oct13 sw - change to cd into simplesi_scratch_handler to run servods OK" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
# echo "pkill -f scratchgpio_handler" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
# echo "cd $RDIR/scratchgpio"$SGHVER >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
# echo "python scratchgpio_handler8.py 127.0.0.1 standard &" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
# echo "scratch.old --document \"$HDIR/Documents/Scratch Projects/rsc.sb\" &" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
#
# chmod +x $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}.sh
#
# #Create new desktop icon for oldscratch version
# echo "[Desktop Entry]" > $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Encoding=UTF-8" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Version=1.0" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Type=Application" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Exec="$RDIR"/scratchgpio"$SGHVER"/oldscratchgpio"$SGHVER".sh" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Icon=scratch" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Terminal=false" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Name=OrigScratch ScratchGPIO "$SGHVER >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Comment= Programming system and content development tool" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "Categories=Application;Education;Development;" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
# echo "MimeType=application/x-scratch-project" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
#
# chown -R $USERID:$GROUPID  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}.desktop
#
#
#
# #Create a new file for old scratchgpioXplus.sh
# echo "#!/bin/bash" > $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
# echo "#Version 0.2 - add in & to allow simulatenous running of handler and Scratch" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
# echo "#Version 0.3 - change sp launches rsc.sb from \"/home/pi/Documents/Scratch Projects\"" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
# echo "#Version 0.4 - 20Mar13 meltwater - change to use provided name for home" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
# echo "#Version 1.0 - 29Oct13 sw - change to cd into simplesi_scratch_handler to run servods OK" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
# echo "pkill -f scratchgpio_handler" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
# echo "cd $RDIR/scratchgpio"$SGHVER >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
# echo "sudo python scratchgpio_handler8.py &" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
# echo "scratch.old --document \"$HDIR/Documents/Scratch Projects/rsc.sb\" &" >> $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
#
# chmod +x $RDIR/scratchgpio${SGHVER}/oldscratchgpio${SGHVER}plus.sh
#
# #Create new desktop icon for plus version
# echo "[Desktop Entry]" > $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Encoding=UTF-8" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Version=1.0" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Type=Application" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Exec="$RDIR"/scratchgpio"$SGHVER"/oldscratchgpio"$SGHVER"plus.sh" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Icon=scratch" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Terminal=false" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Name=OrigScratch ScratchGPIO "$SGHVER"plus" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Comment= Programming system and content development tool" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "Categories=Application;Education;Development;" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
# echo "MimeType=application/x-scratch-project" >>  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop
#
# chown -R $USERID:$GROUPID  $HDIR/Desktop/ScratchGPIO\ Extras/oldscratchgpio${SGHVER}plus.desktop

cp blink11.py $HDIR
cp *.sb $HDIR

echo ""
echo "Finished."
