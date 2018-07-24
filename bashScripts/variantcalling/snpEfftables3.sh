#!/usr/bin/env bash
main_function() {
for i in transcript gene ; do
for j in high moderate ; do
rm -rf /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/[Rr]*
done
done
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/snpEfftables3.log
