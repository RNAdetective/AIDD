#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
##edit Rscripts
echo "Please enter how many samples you have in your experiment.  Enter a number 4-22."
read sample
echo "What is the name of condition 1"
read con1
echo "what is the name of condition 2"
read con2
##this will change condition to specifics you provide
for i in matrixedit.R GLDE.R GOIcountgraph.R Gpathway.R GtopGO.R Gvenn.R; do
sed -i "s/condition_1/"$con1"/g" /media/sf_AIDD/Rscripts/$i
sed -i "s/condition_2/"$con2"/g" /media/sf_AIDD/Rscripts/$i
done
##this changes R script for sample count (how can I put this in a loop
for i in matrixedit.R GLDE.R GOIcountgraph.R Gpathway.R GtopGO.R Gvenn.R ; do
if  [ "$sample" == "6" ]; then 
sed -i 's/2:5/2:7/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1:4/1:6/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/4:8/4:10/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 9, 10, 11, 12, 13, 14/g' /media/sf_AIDD/Rscripts/$i
fi

if  [ "$sample" == "8" ]; then 
sed -i 's/2:6/2:9/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1:5/1:8/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/4:8/4:12/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 11, 12, 13, 14, 15, 16/g' /media/sf_AIDD/Rscripts/$i
fi

if  [ "$sample" == "12" ]; then 
sed -i 's/2:6/2:13/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1:5/1:12/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/4:8/4:14/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 15, 16, 17, 18, 19, 20/g' /media/sf_AIDD/Rscripts/$i
fi

if  [ "$sample" == "16" ]; then 
sed -i 's/2:6/2:17/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1:5/1:16/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/4:8/4:19/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 19, 20, 21, 22, 23, 24/g' /media/sf_AIDD/Rscripts/$i
fi

if  [ "$sample" == "18" ]; then 
sed -i 's/2:5/2:19/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1:4/1:18/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/4:7/4:21/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 21, 22, 23, 24, 25, 26/g' /media/sf_AIDD/Rscripts/$i
fi

if  [ "$sample" == "20" ]; then 
sed -i 's/2:5/2:19/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1:4/1:18/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/4:7/4:21/g' /media/sf_AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 23, 24, 25, 26, 27, 28/g' /media/sf_AIDD/Rscripts/$i
fi
done

}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/Rscript_edits.log