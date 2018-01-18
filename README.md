# RNAseqPipeline

These are the directions to create a new vm image with biolinux8 and then how to use the script to update, download and install all necessary tools for RNAseq_TDPipeline.sh to run which is our RNAseq computational pipeline for transcriptome diversity discovery.


1. Download and set up oracle virtual box machine make sure you download and install http://download.virtualbox.org/virtualbox/5.2.2/Oracle_VM_VirtualBox_Extension_Pack-5.2.2-119230.vbox-extpack inorder to use USB3.0

2. Next download and load our ready to go vm or if you prefer to make your own follow the instructions below.
username = user and password=password

YOU ONLY NEED THESE IF YOU WANT TO CREATE YOUR OWN VB NOT USE THE ONE ALREADY READY TO DOWNLOAD THESE ARE DIRECTIONS FOR WINDOWS HOST MACHINES

1. use the following link to download biolinux8 the .iso file not the .ova file for the vm.
http://nebc.nerc.ac.uk/downloads/bio-linux-8-latest.iso

2. Go to create new machine in the oracle virtual machine window
      select a name, put in linux and ubuntu 64 
      then click VDH create virtual hard disk now and select at least 70G of storage space to create the hard disk.  
      Click create

3. When it asks where to load from click on bio linux 8 .iso file in your file system.
      This will then load the iso file and it is just like you are installing a new os.
      then install biolinux following prompts until it is done.
      Make sure you use username = user and password = password
      When you click restart wait about 15 seconds and you can close the virtualbox and click the option shutdown machine.

4. Double click your new virtualbox and it will start up again.
      Go until the menu devices and select the last option insert guest additions CD image
      then follow the prompts until the program runs and will install guest additions
      this will allow you to resize the screen and have shared folders permissions

5. Restart for this to finish installation.  (shutdown virutalbox and then double click on it again to restart)

6. When the virtualbox restarts it will prompt an upgrade select no upgrade.  (those upgrades do not work with the virtual box we will manually upgrade in the set-up.sh script.

7. You can Use rightCTRL C to switch between scale mode to be able to get the full screen view but you need to have scale mode turned off to see the top menu while in your virtualbox.  When you see the menu bar across the top then go to view menu and select the screen resolution

8. Turn off the virtualbox and check the settings for system.  Make sure you have set aside enough RAM and CPU to run the machine you must select at least 4G of RAM and 1CPU to run at bare minimum.  (Although to run STAR aligner option you must select at least 30G of RAM).  Make sure you have attached you hard drive or shared folder (see the manual for instructions for this set up).

9.  Once you load your new virtual box open command prompt and copy paste the following commands
wget https://github.com/nplonsk2/RNAseqPipeline/raw/master/VMsetup.tar.gz
tar -xvzf VMsetup.tar.gz
bash /home/user/VMsetup/set_up.sh

10. The first prompt will ask you for the password which is password
    The second prompt will ask to hit enter
    The third prompt will ask for you to pick which verison of Java you would like to use the options are 0 1 2 you want to hit 2
    The fourth prompt will ask for 

11. once the operating system and programs are ready copy and paste the following to run the R package setup
##this first command runs command at the root
sudo su
##then enter password which is password then copy and paste the following in the root directory prompt
Rscript /home/user/Pipelines/Rscripts/install_packages.R
##if the script runs into a error where it asks the user for input just exit out and run it again and that should fix the error.
12. You know have a newly constructed VirtualBox capable of running our script for RNAseq transcriptome diversity discovery so copy and paste the following command and follow the on screen prompts or follow the instructions found in the manual.
bash /home/user/TDPipelines/RNAseq_pipeline.sh
