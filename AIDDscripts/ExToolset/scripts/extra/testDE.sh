dir_path=/home/user/AIDDtest
dirres=/home/user/AIDDtest/Results
ExToolset=/home/user/AIDDtest/AIDD/ExToolset/scripts
level=transcript
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
remove_stuff() {
file_in="$dirres"/"$level"_count_matrixedited.csv
cat "$file_in" | awk -F',' '!v[$1]++' >> "$dir_path"/temp.csv
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
file_in="$dirres"/"$level"_count_matrixedited.csv
pheno="$dir_path"/PHENO_DATA.csv
condition_name=SexMDD
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
Rscript "$ExToolset"/DE.R "$file_in" "$pheno" "$set_design" "$level_name" "$rlog" "$log" "$transcounts" "$PoisHeatmap" "$PCA" "$PCA2" "$MDSplot" "$MDSpois" "$resultsall" "$upreg" "$upreg100" "$upregGlist" "$downreg" "$downreg100" "$downregGlist" "$heatmap" "$volcano"
