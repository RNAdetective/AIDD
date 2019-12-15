####################################################################################################################
# RUNS EXTOOLSET FOR DE ANALYSIS INCLUDING PATHWAY DE
####################################################################################################################
DE_R() {
rlog="$dirresDEcal"/rlogandvariance.tiff
log="$dirresDEcal"/logtranscounts.tiff
transcounts="$dirresDEcal"/transcounts2sam.tiff
PoisHeatmap="$dirresDEcal"/PoisHeatmap.tiff
PCA="$dirresDEPCA"/PCAplot.tiff
PCA2="$dirresDEPCA"/PCAplot2.tiff
MDSplot="$dirresDEPCA"/MDSplot.tiff
MDSpois="$dirresDEPCA"/MDSpois.tiff
resultsall="$dirresDELDE"/resultsall.csv
upreg="$dirresDELDE"/upreg.csv
upreg100="$dirresDELDEvd"/upregGListtop100.csv
upregGlist="$dirresDELDEvd"/upregGList.csv
downreg="$dirresDELDE"/downreg.csv
downreg100="$dirresDELDEvd"/downregGListtop100.csv
downregGlist="$dirresDELDEvd"/downregGList.csv
heatmap="$dirresDELDE"/top60heatmap.tiff
volcano="$dirresDELDE"/VolcanoPlot.tiff
ExToolset="$dir_path"/AIDD/ExToolset/scripts
cat "$ExToolset"/DE.R | sed 's/set_design/'$set_design'/g' >> "$dir_path"/tempDE.R
Rscript "$dir_path"/tempDE.R "$file_in" "$pheno" "$set_design" "$level_name" "$rlog" "$log" "$transcounts" "$PoisHeatmap" "$PCA" "$PCA2" "$MDSplot" "$MDSpois" "$resultsall" "$upreg" "$upreg100" "$upregGlist" "$downreg" "$downreg100" "$downregGlist" "$heatmap" "$volcano"
rm "$dir_path"/tempDE.R
}
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
GvennR() {
Rscript "$dir_path"/tempGvenn.R "$file_in" "$file_out" "$image_out"
}
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
run_tools() {
    if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
    then
      if [ -f "$file_in" ]; # IF INPUT THERE
      then
        echo1=$(echo "FOUND "$file_in" STARTING "$tool"")
        #mes_out
        $tool # TOOL
      else
        echo1=$(echo "CANT FIND "$file_in" FOR_THIS "$sample"")
        mes_out # ERROR INPUT NOT THERE
      fi
      if [[ -f "$file_out" ]]; # IF OUTPUT IS THERE
      then
        echo1=$(echo "FOUND "$file_out" FINISHED "$tool"")
        #mes_out # ERROR OUTPUT IS THERE
      else 
        echo1=$(echo "CANT FIND "$file_out" FOR THIS "$sample"")
        #mes_out # ERROR INPUT NOT THERE
      fi
  else
        echo1=FOUND_"$file_out"_FINISHED_"$tool"
        mes_out # ERROR OUTPUT IS THERE
  fi
}
mes_out() {
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
}
####################################################################################################################
# RUNS EXTOOLSET FOR DE ANALYSIS INCLUDING PATHWAY DE
####################################################################################################################
source config.shlib
count_matrix="$1"
level=$(echo "$count_matrix" | cut -d'_' -f1)
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path); 
dirres="$dir_path"/Results;
dirresDE="$dirres"/DESeq2
con_name1=$(config_get con_name1);
con_name2=$(config_get con_name2);
con_name3=$(config_get con_name3);
for condition_name in "$con_name1" "$con_name2" "$con_name3" ;
do
  file_in="$dirresDE"/"$count_matrix".csv
  #cat "$file_in" | sort -t',' -u -k1,1 | uniq >> "$dir_path"/temp.csv
  #temp_file
  echo1=$(echo "STARTING "$file_in"")
  mes_out
  file_in="$dirresDE"/"$count_matrix".csv
  pheno="$dir_path"/PHENO_DATA.csv
  if [ "$2" != "" ];
  then
    set_design="2"
  else
    set_design="$condition_name"
  fi
  level_name="$level"_name
  dirresDElevel="$dirresDE"/"$count_matrix"
  new_dir="$dirresDElevel"
  create_dir
  dirresDElevelcon="$dirresDElevel"/"$condition_name"
  new_dir="$dirresDElevelcon"
  create_dir
  dirresDEcal="$dirresDElevelcon"/calibration
  new_dir="$dirresDEcal"
  create_dir
  dirresDEPCA="$dirresDElevelcon"/PCA
  new_dir="$dirresDEPCA"
  create_dir
  dirresDELDE="$dirresDElevelcon"/DE
  new_dir="$dirresDELDE"
  create_dir
  dirresDELDEvd="$dirresDElevelcon"/DE/vennD
  new_dir="$dirresDELDEvd"
  create_dir
  file_out="$dirresDELDE"/resultsall.csv
  tool=DE_R
  run_tools
####################################################################################################################
# CREATES VENN DIAGRAMS FOR DE ANALYSIS
####################################################################################################################
  upregGlist=$(cat "$dirresDELDEvd"/upregGList.csv)
  downregGlist=$(cat "$dirresDELDEvd"/downregGList.csv)
  echo ""$upregGlist"
"$downregGlist"" >> "$dirresDELDEvd"/updownregGlist.csv
   cat "$dirresDELDEvd"/updownregGlist.csv | sed 's/,/\n/g' | sed 's/ /,/g' | awk -F',' '{for(i=1;i<=NF;i++){A[NR,i]=$i};if(NF>n){n=NF}}
END{for(i=1;i<=n;i++){
for(j=1;j<=NR;j++){
s=s?s","A[j,i]:A[j,i]}
print s;s=""}}' | sed '1d' | sed '1i '$condition_name'upreg,'$condition_name'downreg' >> "$dirresDELDEvd"/temp.csv
  if [ -s "$dirresDELDEvd"/temp.csv ];
  then
    rm "$dirresDELDEvd"/updownregGlist.csv
    mv "$dirresDELDEvd"/temp.csv "$dirresDELDEvd"/updownregGlist.csv
  fi   
  upregGlisttop100=$(cat "$dirresDELDEvd"/upregGListtop100.csv)
  downregGlisttop100=$(cat "$dirresDELDEvd"/downregGListtop100.csv)
  echo ""$upregGlisttop100","$downregGlisttop100"" >> "$dirresDELDEvd"/updownregGlisttop100.csv
  cat "$dirresDELDEvd"/updownregGlisttop100.csv | sed 's/,/\n/g' | sed 's/ /,/g' | awk -F',' '{for(i=1;i<=NF;i++){A[NR,i]=$i};if(NF>n){n=NF}}
END{for(i=1;i<=n;i++){
for(j=1;j<=NR;j++){
s=s?s","A[j,i]:A[j,i]}
print s;s=""}}' | sed '1d' | sed '1i '$condition_name'top100upreg,'$condition_name'top100downreg' >> "$dirresDELDEvd"/temp.csv
  if [ -s "$dirresDELDEvd"/temp.csv ];
  then
    rm "$dirresDELDEvd"/updownregGlisttop100.csv
    mv "$dirresDELDEvd"/temp.csv "$dirresDELDEvd"/updownregGlisttop100.csv
  fi
  for reg in updownGlist updownGlisttop100 ;
  do
    cat "$ExToolset"/tempbarchart.R | sed 's/set_column_name/'$condition_name'top100upreg,'$condition_name'top100downreg/g' | sed 's/set_colors/red,blue/g' | sed 's/set_alpha/0.5,0.5/g' >> "$dir_path"/tempbarchart.R
    bartype=VENN
    file_in="$dirresDELDEvd"/"$reg".csv
    file_out="$dirresDELDEvd"/"$reg".txt
    image_out="$dirresDELDEvd"/"$reg".tiff
    tool=Rbar
    run_tools
    "$dir_path"/tempbarchart.R
  done
done
for GL in Glisttop100 Glist ;
do
  datacond1="$dirresDElevel"/"$con_name1"/DE/vennD/updownreg"$GL".csv
  datacond2="$dirresDElevel"/"$con_name2"/DE/vennD/updownreg"$GL".csv
  datacond3="$dirresDElevel"/"$con_name3"/DE/vennD/updownreg"$GL".csv
  dc1=$(echo "$datacond1" | awk -vORS=, '{ print $1 }' | sed 's/,$//')
  dc2=$(echo "$datacond1" | awk -vORS=, '{ print $2 }' | sed 's/,$//')
  dc3=$(echo "$datacond2" | awk -vORS=, '{ print $1 }' | sed 's/,$//')
  dc4=$(echo "$datacond2" | awk -vORS=, '{ print $2 }' | sed 's/,$//')
  dc5=$(echo "$datacond3" | awk -vORS=, '{ print $1 }' | sed 's/,$//')
  dc6=$(echo "$datacond3" | awk -vORS=, '{ print $2 }' | sed 's/,$//')
  cat "$dc1" "$dc3" "$dc5" | sed '1d' | sed '1i '$con_name1'upreg,'$con_name2'upreg,'$con_name3'upreg' >> "$dirresDElevel"/Allcondupreg"$GL".csv
  cat "$dc2" "$dc4" "$dc6" | sed '1d' | sed '1i '$con_name1'downreg,'$con_name2'downreg,'$con_name3'downreg' >> "$dirresDElevel"/Allconddownreg"$GL".csv
  cat "$ExToolset"/barchart.R | sed 's/set_column_name/'$con_name1'upreg,'$con_name2'upreg,'$con_name3'upreg/g' sed 's/set_colors/"red","blue","yellow"/g' | sed 's/set_alpha/0.5,0.5,0.5/g' >> "$dir_path"/tempbarchart.R
  bartype=VENN
  file_in="$dirresDElevel"/Allcondupreg"$GL".csv
  file_out="$dirresDELDEvd"/Allcondupreg"$GL".txt
  image_out="$dirresDELDEvd"/Allcondupreg"$GL".tiff
  tool=Rbar
  run_tools
  rm "$dir_path"/tempbarchart.R
  bartype=VENN
  file_in="$dirresDElevel"/Allconddownreg"$GL".csv
  file_out="$dirresDELDEvd"/Allconddownreg"$GL".txt
  image_out="$dirresDELDEvd"/Allconddownreg"$GL".tiff
  tool=Rbar
  run_tools
  rm "$dir_path"/tempbarchart.R
done
