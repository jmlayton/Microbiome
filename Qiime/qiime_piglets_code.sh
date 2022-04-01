#conda activate qiime2-2021.11
# vim -b filename
# :%s/\r$//
# :x
# then you can run nohup ./qiime_piglets_code.sh &
mkdir visualizations

#import all fastq.gz files
qiime tools import \
    --type 'SampleData[PairedEndSequencesWithQuality]' \
    --input-path maltecca-piglets-fastq \
    --input-format CasavaOneEightSingleLanePerSampleDirFmt \
    --output-path maltecca_piglets_demux.qza

#visulization demultiplexed data sequence quality
qiime demux summarize \
  --i-data maltecca_piglets_demux.qza \
  --o-visualization visualizations/maltecca_piglets_demux.qza

#trim and filter reads
mkdir ASVs
cp silva-138-99-nb-classifier.qza ASVs/silva-138-99-nb-classifier.qza

#commented out p-qscore - 30
qiime dada2 denoise-paired \
--i-demultiplexed-seqs maltecca_piglets_demux.qza \
--p-trim-left-f 13 \
--p-trim-left-r 13 \
--p-trunc-len-f 145 \
--p-trunc-len-r 145 \
--o-table ASVs/asv_table.qza \
--o-representative-sequences ASVs/rep-seqs.qza \
--o-denoising-stats ASVs/stats-dada2.qza 

#visulize denoised reads -----------------------------
cp maltecca_metadata_piglets.tsv ASVs/maltecca_metadata_piglets.tsv
cd ASVs
mkdir visualizations
qiime feature-table summarize \
    --i-table asv_table.qza \
    --o-visualization visualizations/asv_table.qzv \
    --m-sample-metadata-file maltecca_metadata_piglets.tsv

qiime feature-table tabulate-seqs \
    --i-data rep-seqs.qza \
    --o-visualization visualizations/rep-seqs.qzv

qiime metadata tabulate \
    --m-input-file stats-dada2.qza \
    --o-visualization visualizations/stats-dada2.qzv

###end visualizations of reads#######

### Follow alpha-diversity.txt and beta-diversity.txt files -----------------------------------
### For visualization of alpha diversity follow r-visualizations

## Generate tree for phylogenetic diversity analyses
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --output-dir phylogeny-align-to-tree-mafft-fasttree

#classify data with silva (be sure to cite rescript in paper) and generate taxonomy table --------------------------------

qiime feature-classifier classify-sklearn \
    --i-classifier silva-138-99-nb-classifier.qza \
    --i-reads rep-seqs.qza \
    --p-reads-per-batch 1000 \
    --p-n-jobs -1 \
    --o-classification asv_tax_sklearn.qza

#Generate output tables -------------------
qiime tools export \
--input-path asv_table.qza --output-path asv_table

biom convert -i asv_table/feature-table.biom -o asv-table.tsv --to-tsv

qiime tools export \
    --input-path asv_tax_sklearn.qza \
    --output-path asv_tax_dir

#Generate representative sequence fasta file:
qiime tools export --input-path rep-seqs.qza --output-path export_dir

qiime metadata tabulate \
  --m-input-file asv_tax_sklearn.qza \
  --o-visualization visualizations/asv_tax_sklearn.qzv

#view taxonomic composition of samples --------------------
qiime taxa barplot \
  --i-table asv_table.qza \
  --i-taxonomy asv_tax_sklearn.qza \
  --m-metadata-file maltecca_metadata_piglets.tsv \
  --o-visualization visualizations/taxa-bar-plots.qzv

### Move to R and follow compile taxonomy and count tables ------------------