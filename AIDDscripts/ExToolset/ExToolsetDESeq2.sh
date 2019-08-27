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
sed -i 's/set_design/'$condition_name'/g' "$ExToolset"/DE.R
Rscript "$ExToolset"/DE.R "$file_in" "$pheno" "$set_design" "$level_name" "$rlog" "$log" "$transcounts" "$PoisHeatmap" "$PCA" "$PCA2" "$MDSplot" "$MDSpois" "$resultsall" "$upreg" "$upreg100" "$upregGlist" "$downreg" "$downreg100" "$downregGlist" "$heatmap" "$volcano"
sed -i 's/'$condition_name'/set_design/g' "$ExToolset"/DE.R
}
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
GvennR() {
Rscript "$ExToolset"/Gvenn.R "$file_in" "$file_out" "$image_out"
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
source config.shlib
count_matrix="$1"
level=$(echo "$count_matrix" | cut -d'_' -f1)
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path); 
dirres="$dir_path"/Results;
con_name1=$(config_get con_name1);
con_name2=$(config_get con_name2);
con_name3=$(config_get con_name3);
cell_line="$1"
split_csv=$(echo "sex.csv")
if [ "$cell_line" == "1" ];
then
  INPUT="$dir_path"/"$split_csv"
  OLDIFS=$IFS
  {
  IFS=,
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  read
  while read freq name
  do
    source config.shlib;
    count_matrix="$1"
    level=$(echo "$count_matrix" | cut -d'_' -f1)
    split_csv=$(echo "sex.csv")
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirres="$dir_path"/Results
    con_name1=$(config_get con_name1);
    con_name2=$(config_get con_name2);
    con_name3=$(config_get con_name3);
    echo ""$name""
    cat "$dir_path"/PHENO_DATA.csv | sed -n '/^'$name'/p' | sed '1i samp_name,run,condition,sample,cell,reads' >> "$dir_path"/PHENO_DATA"$name".csv
    for level in gene transcript ;
    do
      name1=$(awk -F, 'NR==3{print $2}' "$dir_path"/"$split_csv")
      name2=$(awk -F, 'NR==4{print $2}' "$dir_path"/"$split_csv")
      name3=$(awk -F, 'NR==2{print $2}' "$dir_path"/"$split_csv")
      if [ "$name"  == "$name1" ];
      then
        column_num=$(cat "$dir_path"/PHENO_DATA"$name".csv | wc -l) # 1+the first group
        echo ""$column_num""
        cat "$dirres"/"$count_matrix".csv | cut -d',' -f1-"$column_num" >> "$dirres"/"$count_matrix""$name".csv
      fi
      if [ "$name" == "$name2" ];
      then
        column_num=$(cat "$dir_path"/PHENO_DATA"$name".csv | wc -l)
        start_num=$(expr "2" + "$freq")
        end_num=$(expr "1" + "$freq" + "$freq")
        column_num=$(echo ""$start_num"-"$end_num"")
        echo ""$column_num""
        cat "$dirres"/"$count_matrix".csv | cut -d',' -f1,"$column_num" >> "$dirres"/"$count_matrix""$name".csv
      fi
      if [ "$name" == "$name3" ];
      then
        column_num=$(cat "$dir_path"/PHENO_DATA"$name".csv | wc -l)
        start_num=$(expr "2" + "$freq" + "$freq")
        end_num=$(expr "1" + "$freq" + "$freq" + "$freq")
        column_num=$(echo ""$start_num"-"$end_num"")
        echo ""$column_num""
        cat "$dirres"/"$count_matrix".csv | cut -d',' -f1,"$column_num" >> "$dirres"/"$count_matrix""$name".csv
      fi
    done
    for condition_name in "$con_name1" "$con_name2" "$con_name3" ;
    do
      file_in="$dirres"/"$count_matrix""$name".csv
      cat "$file_in" | awk -F',' '!a[$1]++' | sort -u -t',' -k1,1 >> "$dir_path"/temp.csv
      temp_file
      echo1=$(echo "STARTING DESEQ2 FOR level="$level", and condition="$condition_name"")
      mes_out
      file_in="$dirres"/"$count_matrix""$name".csv
      pheno="$dir_path"/PHENO_DATA"$name".csv
      set_design="$condition_name"
      level_name=level_name
      dirresDE="$dirres"/DESeq2
      new_dir="$dirresDE"
      create_dir
      dirresDElevel="$dirresDE"/"$level"
      new_dir="$dirresDElevel"
      create_dir
      dirresDElevelcon="$dirresDElevel"/"$condition_name"
      new_dir="$dirresDElevelcon"
      create_dir
      dirresDElevelconname="$dirresDElevelcon"/"$name"
      new_dir="$dirresDElevelconname"
      create_dir
      dirresDEcal="$dirresDElevelconname"/calibration
      new_dir="$dirresDEcal"
      create_dir
      dirresDEPCA="$dirresDElevelconname"/PCA
      new_dir="$dirresDEPCA"
      create_dir
      dirresDELDE="$dirresDElevelconname"/DE
      new_dir="$dirresDELDE"
      create_dir
      dirresDELDEvd="$dirresDElevelconname"/DE/vennD
      new_dir="$dirresDELDEvd"
      create_dir
      file_out="$dirresDELDE"/resultsall.csv
      tool=DE_R
      run_tools
      #for updown in upregGlist upreg100 downreg100 downregGlist ;
      #do
      #   file_in="$dirresDELDEvd"/"$updown".csv
      #   file_out="$dirresDELDEvd"/"$updown".txt
      #   image_out="$dirresDELDEvd"/"$updown".tiff
      #   tool=GvennR
      #   run_tools
      #done
    done
  done
  } < $INPUT
  IFS=$OLDIFS # creates count matrix
  for condition_name in "$con_name1" "$con_name2" "$con_name3" ;
  do
    file_in="$dirres"/"$count_matrix".csv
    cat "$file_in" | awk -F',' '!v[$1]++' >> "$dir_path"/temp.csv
    temp_file
    echo1=$(echo "STARTING "$file_in"")
    mes_out
    file_in="$dirres"/"$count_matrix".csv
    pheno="$dir_path"/PHENO_DATA.csv
    set_design="$condition_name"
    level_name=level_name
    dirresDE="$dirres"/DESeq2
    new_dir="$dirresDE"
    create_dir
    dirresDElevel="$dirresDE"/"$level"
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
    for updown in upregGlist upreg100 downreg100 downregGlist ;
    do
      file_in="$dirresDELDEvd"/"$updown".csv
      file_out="$dirresDELDEvd"/"$updown".txt
      image_out="$dirresDELDEvd"/"$updown".tiff
      tool=GvennR
      #run_tools
    done
  done
else
  for condition_name in "$con_name1" "$con_name2" "$con_name3" ;
  do
    file_in="$dirres"/"$count_matrix".csv
   # cat "$file_in" | sort -t',' -u -k1,1 | uniq >> tempor.csv
   # if [ -f tempor.csv ];
   # then
   #   rm "$file_in"
   #   mv tempor.csv "$file_in"
   # fi
    echo1=$(echo "STARTING "$file_in"")
    mes_out
    file_in="$dirres"/"$count_matrix".csv
    pheno="$dir_path"/PHENO_DATA.csv
    set_design="$condition_name"
    level_name="$level"_name
    dirresDE="$dirres"/DESeq2
    new_dir="$dirresDE"
    create_dir
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
      sed -i 's/set_column_name/'$condition_name'top100upreg,'$condition_name'top100downreg/g' "$ExToolset"/barchart.R
      sed -i 's/set_colors/red,blue/g' "$ExToolset"/barchart.R
      sed -i 's/set_alpha/0.5,0.5/g' "$ExToolset"/barchart.R
      bartype=VENN
      file_in="$dirresDELDEvd"/"$reg".csv
      file_out="$dirresDELDEvd"/"$reg".txt
      image_out="$dirresDELDEvd"/"$reg".tiff
      tool=Rbar
      run_tools
      sed -i 's/'$condition_name'top100upreg,'$condition_name'top100downreg/set_column_name/g' "$ExToolset"/barchart.R
      sed -i 's/red,blue/set_colors/g' "$ExToolset"/barchart.R
      sed -i 's/0.5,0.5/set_alpha/g' "$ExToolset"/barchart.R
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
    sed -i 's/set_column_name/'$con_name1'upreg,'$con_name2'upreg,'$con_name3'upreg/g' "$ExToolset"/barchart.R
    sed -i 's/set_colors/"red","blue","yellow"/g' "$ExToolset"/barchart.R
    sed -i 's/set_alpha/0.5,0.5,0.5/g' "$ExToolset"/barchart.R
    bartype=VENN
    file_in="$dirresDElevel"/Allcondupreg"$GL".csv
    file_out="$dirresDELDEvd"/Allcondupreg"$GL".txt
    image_out="$dirresDELDEvd"/Allcondupreg"$GL".tiff
    tool=Rbar
    run_tools
    sed -i 's/'$con_name1'upreg,'$con_name2'upreg,'$con_name3'upreg/set_column_name/g' "$ExToolset"/barchart.R
    sed -i 's/"red","blue","yellow"/set_colors/g' "$ExToolset"/barchart.R
    sed -i 's/0.5,0.5,0.5/set_alpha/g' "$ExToolset"/barchart.R
    bartype=VENN
    file_in="$dirresDElevel"/Allconddownreg"$GL".csv
    file_out="$dirresDELDEvd"/Allconddownreg"$GL".txt
    image_out="$dirresDELDEvd"/Allconddownreg"$GL".tiff
    tool=Rbar
    run_tools
    sed -i 's/'$condition_name'upreg,'$condition_name'downreg/set_column_name/g' "$ExToolset"/barchart.R
    sed -i 's/"red","blue","yellow"/set_colors/g' "$ExToolset"/barchart.R
    sed -i 's/0.5,0.5,0.5/set_alpha/g' "$ExToolset"/barchart.R
  done
fi
