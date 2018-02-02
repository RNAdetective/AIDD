# Automated Isoform Diversity Detector



## Getting Started

These are the directions to download the premade AIDDPipeline image or to create a new vm image with biolinux8 and how to use the script to update, download and install all necessary tools for AIDD.sh to run which is our RNAseq computational pipeline for transcriptome diversity discovery.

### Prerequisites

1. Download and set up oracle virtual box machine 
```
https://www.virtualbox.org/wiki/Downloads 
```
2. Download and install the extension pack as well.
```
https://download.virtualbox.org/virtualbox/5.2.6/Oracle_VM_VirtualBox_Extension_Pack-5.2.6-120293.vbox-extpack
```

### Installing

3. Download our ready to go AIDD virtualbox.
```
https://drive.google.com/open?id=1Wj6H0a1K57gmox50YAVQdGcNFPjN-5sa
```
4. Uncompress files.

5. Open Virtualbox manager and under the menu Machine select add.  A new pop window will allow you to find the file you just uncompressed.  Then click open.  AIDDv1.0 will now appear on your list of virtualboxes.

6. Make sure you check your setting for the machine and you have the correct amount of resources allocated to the virtualbox from teh host machine.
```
You do this by selecting a virtualbox then clicking on settings.  

Under the option in the menu on the right select systems. 

There are two tabs you need to check on the right.  

Under motherboard make sure the blue marker is in the green portion of 

the bar for how much RAM to allocate to the virtual box.  

Do the same under the tab processors.  

The top green bar is how much CPU to give to virtualbox 

and this needs to be in the green as well. 
```
7. Set up external, internal hard drive, or shared folder path for the pipeline to store files to.  The virtual box only has enough memory to run to the tools you will need a hard drive external to the virtual box below are the three options you have and instructions to create each of them.  Just make sure the hard drive has enough space You will need about 50G for each file or more if you use deep sequencing.

A.	If you choose the external drive make sure you set up the virtual box to recognize your drive.  
```
Do this by going to the settings and selecting USB.  

Make sure you have the right 2.0 or 3.0 option selected and click add device.  

Then select the appropriate device from the menu.  

Then apply changes and restart the virtualbox.  

The final path should be /media/user/”whatever you named you external drive”
```
B.	If you choose the internal drive use these instructions to add an internal hard drive space. 
```
Click settings and then select Storage.  

Highlight Controller: SATA and then at the bottom there is a 

blue drive button with a green plus select this one.  

Two options will appear select the add hard disk option.  

Click create new disk and in the new window select VHD (virtual hard disk) then click Next.  

Select Dynamically allocated up to appropriate size for your project and machine we suggest no smaller then 500GB.  

The new drive should appear in the list.  

Now you can open the virtual machine and you will have to format the new disk before you can use it.  

Go to search computer and type in disks. 

Click on the disks icon that appears. 

A new window will pop up and on the left will be a list of disks.  

Select your new hard drive and then click on the circle icon in the upper right corner which is the settings menu.  

Select format from this menu.  

In the new window select quick overwrite and click format. 

Once this is done select the + icon near the middle of the window.  

In the new pop up window don’t change any options just add a name in the name box.  

Once this is done close click the triangle “play” button to mount the drive and close the windows.  

Your new drive should appear below computer in the folder menu.  

Supply this path to the first prompt in the pipeline.  

The final path should be /media/user/”whatever you named it”
```
C.	The last option is to create a shared folder on your host system.  
```
Create your folder on your host system and make sure you give it share permissions.  

Go into the setting in the virtualbox and click on shared folders. 

Click on the folder icon with the + sign on top of it.  

This will create a popup window and you should select you folder path by clicking the drop down option and click on other.  

This will create a pop up window and you can select your new shared folder. 

After you select the folder the pop up will close and you 

should make sure the auto-mount box is checked and make permanent 

box if you want the folder to stay shared for more then one session.  

Then click ok.  

Your new folder should show up on the list then click ok.  

Now start the virtual box and you should see you new folder under devices in the folder menu.  

Then use this path for the pipeline it should be /media/sf_”name of folder”.
```
### Creating VM

If you prefer to create your own virtualbox instead of downloading the premade image follow this next series of steps.  But you do not have to do these if you are going to use the premade virutalbox.

1. use the following link to download biolinux8 the .iso file not the .ova file for the vm.
```
http://nebc.nerc.ac.uk/downloads/bio-linux-8-latest.iso
```
2. Go to create new machine in the oracle virtual machine window by clicking the new button
```
select a name, put in linux and ubuntu 64 
then click VDH create virtual hard disk now and select at least 40G of storage space to create the hard disk.  
 Click create
 ```
3. When it asks where to load from click on bio linux 8 .iso file in your file system.
 ```
 This will then load the iso file and it is just like you are installing a new os.
 then install biolinux following prompts until it is done.
 Hit Continue make sure you erase disk options and keep clicking continue
 Make sure you use username = user and password = password
 When you click restart wait about 15 seconds and you can close the virtualbox and click the option shutdown machine.
 ```
4. Make sure you have set aside enough RAM and CPU to run the machine you must select at least 4G of RAM and 1CPU to run at bare minimum.  
```
(Although to run STAR aligner option you must select at least 30G of RAM).  

Check the settings system.  

Then check motherboard and processor make sure all the blue markers are in the green for your machine.  
```
5.  Once you load your new virtual box open command prompt and copy paste the following commands
```
wget https://github.com/nplonsk2/AIDD/raw/master/VMsetup.tar.gz

tar -xvzf VMsetup.tar.gz

bash /home/user/VMsetup/set_up.sh
```
6. The program will run and ask you for the following prompts
```
   The first prompt will ask you for the password which is password

a. The second prompt will ask to hit enter

b. The third prompt will ask which version you want to keep you want to keep current version you want the default hit n

c. The fourth promt It will prompt for the password again enter password

d. The fifth prompt will ask for you to pick which verison of Java you would like to use the options are 0 1 2 you want to hit 2

e. The sixth prompt will ask for you to hit enter again
```
7. once the operating system and programs are ready copy and paste the following to run the R package setup
```
##this first command runs command at the root

sudo su

##copy and paste the following in the root directory prompt

Rscript /home/user/AIDD/Rscripts/install_packages.R

##if the script runs into a error where it asks the user for input just exit out and run it again and that should fix the error.
Once the Rscript is done running.  
```
Close the virtualbox and restart again.  Now you should be able to click on view and click on the last option virtual screen 1.  A side bar will pop up and you can select the proper screen resolution for your computer. You can hold right ctrl and press c to adjust to fill mode then make the window larger.  This right ctrl + c with toggle between these two views.

You now have a newly constructed copy of AIDDv1.0virtualbox and you must conitnue from step 5 above Installing

## Running AIDD

To Run AIDD for RNAseq transcriptome diversity discovery copy and paste the following command and follow the on screen prompts or follow the instructions found in the manual.
```
bash /home/user/AIDD/AIDD.sh
```

## Deployment



## Built With
*[SRAtoolkit] (https://www.ncbi.nlm.nih.gov/sra/docs/toolkitsoft/)

*[Samtools] (http://samtools.sourceforge.net/)

*[HISAT2] (https://ccb.jhu.edu/software/hisat2/index.shtml)

*[Picard] (http://broadinstitute.github.io/picard/)

*[Stringtie] (https://ccb.jhu.edu/software/stringtie/)

*[STAR] (https://github.com/alexdobin/STAR)

*[Cuffdiff/Cufflinks] (http://cole-trapnell-lab.github.io/cufflinks/cuffdiff/)

*[Kallisto] (https://pachterlab.github.io/kallisto/about)

*[Salmon] (http://salmon.readthedocs.io/en/latest/salmon.html)

*[Bioconductor packages] (https://www.bioconductor.org/)

R packages

*[DESeq2] (https://bioconductor.org/packages/release/bioc/html/DESeq2.html)

*[DEXseq] (http://bioconductor.org/packages/release/bioc/html/DEXSeq.html)

*[Ballgown] (http://bioconductor.org/packages/release/bioc/html/ballgown.html)

*[Ggplot2] (https://cran.r-project.org/web/packages/ggplot2/index.html)

*[topGO] (http://bioconductor.org/packages/release/bioc/html/topGO.html)

*[GATK] (https://software.broadinstitute.org/gatk/)

*[snpEff] (http://snpeff.sourceforge.net/)

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## License

