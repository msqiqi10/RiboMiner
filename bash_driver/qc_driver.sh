ls -Sr merged_out/0/*.bam | xargs -I {} bash bash_scripts/quality_ctrl.sh {} ribominer_out/ ref/annot/ ref/Arabidopsis_thaliana.TAIR10.57.gtf ref/&
ls -Sr merged_out/15/*.bam | xargs -I {} bash bash_scripts/quality_ctrl.sh {} ribominer_out/ ref/annot/ ref/Arabidopsis_thaliana.TAIR10.57.gtf ref/&
ls -Sr merged_out/30/*.bam | xargs -I {} bash bash_scripts/quality_ctrl.sh {} ribominer_out/ ref/annot/ ref/Arabidopsis_thaliana.TAIR10.57.gtf ref/&
wait
