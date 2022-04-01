conda activate qiime2-2021.11
qiime diversity alpha --i-table maltecca-table.qza --p-metric simpson --o-alpha-diversity alpha_diversity/simpson.qza 
qiime diversity alpha-group-significance --i-alpha-diversity alpha_diversity/simpson.qza  --m-metadata-file maltecca_metadata_piglets.tsv --o-visualization visualizations/simpson.qzv 
