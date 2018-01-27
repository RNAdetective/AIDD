# Automated Isoform Diversity Detective Pipeline

These are the directions to download the premade AIDDPipeline image or to create a new vm image with biolinux8 and how to use the script to update, download and install all necessary tools for AIDDPipeline.sh to run which is our RNAseq computational pipeline for transcriptome diversity discovery.

Everyone starts here:
1. Download and set up oracle virtual box machine https://www.virtualbox.org/wiki/Downloads make sure you also download and install https://download.virtualbox.org/virtualbox/5.2.6/Oracle_VM_VirtualBox_Extension_Pack-5.2.6-120293.vbox-extpack inorder for shared folders and other things to work.

2. Next download and load our ready to go vm from "link is in progress" or if you prefer to make your own follow the instructions below.
This is the account details for the vbox username = user and password=password.

Those of you that wish to create your own VM instead of using the pre constructed one do these next steps.  Those of you who downloads the pre made version can skep these next steps.  Pick up were it says everyone do these step.

Again YOU ONLY NEED THESE IF YOU WANT TO CREATE YOUR OWN VB NOT USE THE ONE ALREADY READY TO DOWNLOAD THESE ARE DIRECTIONS FOR WINDOWS HOST MACHINES

1. use the following link to download biolinux8 the .iso file not the .ova file for the vm.
http://nebc.nerc.ac.uk/downloads/bio-linux-8-latest.iso

2. Go to create new machine in the oracle virtual machine window by clicking the new button
      select a name, put in linux and ubuntu 64 
      then click VDH create virtual hard disk now and select at least 40G of storage space to create the hard disk.  
      Click create

3. When it asks where to load from click on bio linux 8 .iso file in your file system.
      This will then load the iso file and it is just like you are installing a new os.
      then install biolinux following prompts until it is done.
      Hit Continue make sure you erase disk options and keep clicking continue
      Make sure you use username = user and password = password
      When you click restart wait about 15 seconds and you can close the virtualbox and click the option shutdown machine.

4. Double click your new virtualbox and it will start up again.
      Go until the menu devices and select the last option insert guest additions CD image
      then follow the prompts until the program runs and will install guest additions
      this will allow you to resize the screen and have shared folders permissions

5. Restart for this to finish installation.  (shutdown virutalbox and then double click on it again to restart)

6. When the virtualbox restarts it will prompt an upgrade select no upgrade.  
(those upgrades do not work with the virtual box we will manually upgrade in the set-up.sh script)

7. You can Use rightCTRL C to switch between scale mode to be able to get the full screen view but you need to have scale mode turned off to see the top menu while in your virtualbox.  When you see the menu bar across the top then go to view menu and select the screen resolution

8. Turn off the virtualbox and check the settings for system.  Make sure you have set aside enough RAM and CPU to run the machine you must select at least 4G of RAM and 1CPU to run at bare minimum.  (Although to run STAR aligner option you must select at least 30G of RAM).  Make sure you have attached you hard drive or shared folder (see the manual for instructions for this set up).

9.  Once you load your new virtual box open command prompt and copy paste the following commands
wget https://github.com/nplonsk2/RNAseqPipeline/raw/master/VMsetup.tar.gz
tar -xvzf VMsetup.tar.gz
bash /home/user/VMsetup/set_up.sh

10. The first prompt will ask you for the password which is password

a. The second prompt will ask to hit enter

b. The third prompt will ask which version you want to keep you want to keep current version you want the default hit n

c. The fourth promt It will prompt for the password again enter password

d. The fifth prompt will ask for you to pick which verison of Java you would like to use the options are 0 1 2 you want to hit 2

e. The sixth prompt will ask for you to hit enter again

11. once the operating system and programs are ready copy and paste the following to run the R package setup

##this first command runs command at the root

sudo su

##copy and paste the following in the root directory prompt

Rscript /home/user/AIDD/Rscripts/install_packages.R

##if the script runs into a error where it asks the user for input just exit out and run it again and that should fix the error.

Everyone regardless of how you set up your virtual image needs to do the following last two steps.

12. Set up external, internal hard drive, or shared folder path for the pipeline to store files to.  The virtual box only has enough memory to run to the tools you will need a hard drive external to the virtual box below are the three options you have and instructions to create each of them.  Just make sure the hard drive has enough space You will need about 50G for each file or more if you use deep sequencing.

A.	If you choose the external drive make sure you set up the virtual box to recognize your drive.  Do this by going to the settings and selecting USB.  Make sure you have the right 2.0 or 3.0 option selected and click add device.  Then select the appropriate device from the menu.  Then apply changes and restart the virtualbox.  The final path should be /media/user/”whatever you named you external drive”

B.	If you choose the internal drive use these instructions to add an internal hard drive space.  Click settings and then select Storage.  Highlight Controller: SATA and then at the bottom there is a blue drive button with a green plus select this one.  Two options will appear select the add hard disk option.  Click create new disk and in the new window select VHD (virtual hard disk) then click Next.  Select Dynamically allocated up to appropriate size for your project and machine we suggest no smaller then 500GB.  The new drive should appear in the list.  Now you can open the virtual machine and you will have to format the new disk before you can use it.  Go to search computer and type in disks.  Click on the disks icon that appears.  A new window will pop up and on the left will be a list of disks.  Select your new hard drive and then click on the circle icon in the upper right corner which is the settings menu.  Select format from this menu.  In the new window select quick overwrite and click format.  Once this is done select the + icon near the middle of the window.  In the new pop up window don’t change any options just add a name in the name box.  Once this is done close click the triangle “play” button to mount the drive and close the windows.  Your new drive should appear below computer in the folder menu.  Supply this path to the first prompt in the pipeline.  The final path should be /media/user/”whatever you named it”

C.	The last option is to create a shared folder on your host system.  Create your folder on your host system and make sure you give it share permissions.  Go into the setting in the virtualbox and click on shared folders.  Click on the folder icon with the + sign on top of it.  This will create a popup window and you should select you folder path by clicking the drop down option and click on other.  This will create a pop up window and you can select your new shared folder.  After you select the folder the pop up will close and you should make sure the auto-mount box is checked and make permanent box if you want the folder to stay shared for more then one session.  Then click ok.  Your new folder should show up on the list then click ok.  Now start the virtual box and you should see you new folder under devices in the folder menu.  Then use this path for the pipeline it should be /media/sf_”name of folder”.

if you can't see your shared folder you can try these next few steps to fix the guest additions error.

sudo apt-get update

sudo apt-get upgrade

sudo apt-get install build-essential module-assistant

sudo m-a prepare

sudo sh /media/user/VBox_GAs_5.2.6/autorun.sh

14.You know have a newly constructed VirtualBox capable of running our script for RNAseq transcriptome diversity discovery so copy and paste the following command and follow the on screen prompts or follow the instructions found in the manual.

bash /home/user/TDPipelines/AIDD.sh
