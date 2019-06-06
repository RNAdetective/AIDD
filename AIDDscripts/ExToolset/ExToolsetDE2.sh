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
sed -i 's/set_design/'$condition_name'/g' "$ExToolset"/DE.R
Rscript "$ExToolset"/DE.R "$file_in" "$pheno" "$set_design" "$level_name" "$rlog" "$log" "$transcounts" "$PoisHeatmap" "$PCA" "$PCA2" "$MDSplot" "$MDSpois" "$resultsall" "$upreg" "$upreg100" "$upregGlist" "$downreg" "$downreg100" "$downregGlist" "$heatmap" "$volcano"
sed -i 's/'$condition_name'/set_design/g' "$ExToolset"/DE.R
}
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
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
source config.shlib
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path); 
ExToolset="$dir_path"/AIDD/ExToolset/scripts
####################################################################################################################
# RUNS EXTOOLSET FOR DE ANALYSIS USING DESeq2
####################################################################################################################
#need to add in how to split phenodata and count matrix to just the samples for that analysis
    level=gene
   condition_name=Suicide
    data_set=FemaleSuicide
    dirres="$dir_path"/Results/"$data_set"
    file_in="$dir_path"/Results/"$level"_count_matrixedited"$data_set".csv
    cat "$file_in" | awk -F',' '!v[$1]++' >> "$dir_path"/temp.csv
    temp_file
    echo1=$(echo "STARTING "$file_in"")
    mes_out
    file_in="$dir_path"/Results/"$level"_count_matrixedited"$data_set".csv
    pheno="$dir_path"/PHENO_DATA"$data_set".csv
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
      bartool=Venn
      tool=Rbar
          column_nam1=$(echo ""$level""$impact""$con_name2"_"$cond_2""$con_name3"_yes"$snptype"")
          column_nam2=$(echo ""$level""$impact""$con_name2"_"$cond_2""$con_name3"_no"$snptype"")
          set_column_name=$(echo ""$column_nam1","$column_nam2"")
         # sed 's/set_column_name/'$set_column_name'/g' "$ExToolset"/barcharts.R
          #run_tools
         # sed 's/'$set_column_name'/set_column_name/g' "$ExToolset"/barcharts.R
    done
