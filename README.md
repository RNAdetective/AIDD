# RNAseqPipeline

These are the directions to create a new vm image with biolinux8 and then how to use the script to update, download and install all necessary tools for RNAseq_TDPipeline.sh to run which is our RNAseq computational pipeline for transcriptome diversity discovery.

YOU ONLY NEED THESE IF YOU WANT TO CREATE YOUR OWN VB NOT USE THE ONE ALREADY READY TO DOWNLOAD

Download and set up oracle virtual box machine make sure you download and install http://download.virtualbox.org/virtualbox/5.2.2/Oracle_VM_VirtualBox_Extension_Pack-5.2.2-119230.vbox-extpack inorder to use USB3.0

Next download and load our ready to go vm or if you prefer to make your own follow the instructions below.
username = user and password=password

then downloads biolinux8 the .iso file not the .ova file for the vm.
http://nebc.nerc.ac.uk/downloads/bio-linux-8-latest.iso

Go to create new machine
select a name, put in linux and ubuntu 64 
then click VDH create virtual hard disk now and select at least 70G of storage space to create the hard disk.  Click create

then when it asks where to load from click on bio linux 8 .iso file in your file system.
This will then load the iso file and it is just like you are installing a new os.
then install biolinux following prompts until it is done.
When you click restart you can close the virtualbox and click the option shutdown.

Then double click your new virtualbox and it will start up again.
Go until the menu devices and select the last option insert guest additions CD image
then follow the prompts until the program runs and will install guest additions
this will allow you to resize the screen

Then restart for this to finish installation.  (shutdown virutalbox and then double click on it again to restart)

when the virtualbox restarts it will prompt an upgrade select no upgrade.  (those upgrades do not work with the virtual box we will manually upgrade in the set-upCode.sh script.

you can Use rightCTRL C to switch between scale mode to be able to get the full screen view but you need to have scale mode turned off to see the top menu while in your virtualbox.  When you see the menu bar across the top then go to view menu and select the screen resolution

turn off the virtualbox and check the settings for system.  Make sure you have set aside enough RAM and CPU to run the machine you must select at least 4G of RAM and 1CPU to run at bare minimum.  (Although to run STAR aligner option you must select at least 30G of RAM).  Make sure you have attached you hard drive (see manual for instructions for this set up).

Then download Pipelines.tar.gz, uncompress and move to /home/user the Pipelines folder

then copy and paste
bash /home/user/Pipelines/set_upCode.sh

You will be prompted through out this script running follow along with all prompts answering y when prompted y or n or enter when prompted to press enter however one of the first prompts will ask you to enter 0 1 or 2 you will enter 2 and near the end when it is updating R it will give you more options then just y or n at this point you will select n.  

once the operating system and programs are ready copy and paste the following to run the R package setup
##this first command runs command at the root
sudo su
##then enter password then copy and paste the following in the root directory prompt
Rscript /home/user/Pipelines/Rscripts/install_packages.R
