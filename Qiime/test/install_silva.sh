# run up to mkdir silva 
# wget https://data.qiime2.org/distro/core/qiime2-2021.11-py38-linux-conda.yml
# conda env create -n qiime2-2021.11 --file qiime2-2021.11-py38-linux-conda.yml
# OPTIONAL CLEANUP
# rm qiime2-2021.11-py38-linux-conda.yml
# conda activate qiime2-2021.11
# conda install -c conda-forge -c bioconda -c qiime2 -c defaults xmltodict
# pip install git+https://github.com/bokulich-lab/RESCRIPt.git

mkdir silva
cd silva
#conda install -c conda-forge -c bioconda -c qiime2 -c defaults xmltodict
#pip install git+https://github.com/bokulich-lab/RESCRIPt.git
#classify data with silva (be sure to cite rescript in paper)

qiime rescript get-silva-data \
    --p-version '138.1' \
    --p-target 'SSURef_NR99' \
    --p-include-species-labels \
    --o-silva-sequences silva-138.1-ssu-nr99-rna-seqs.qza \
    --o-silva-taxonomy silva-138.1-ssu-nr99-tax.qza 

qiime rescript reverse-transcribe \
    --i-rna-sequences silva-138.1-ssu-nr99-rna-seqs.qza \
    --o-dna-sequences silva-138.1-ssu-nr99-seqs.qza

qiime rescript cull-seqs \
    --i-sequences silva-138.1-ssu-nr99-seqs.qza \
    --o-clean-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza

qiime rescript filter-seqs-length-by-taxon \
    --i-sequences silva-138.1-ssu-nr99-seqs-cleaned.qza \
    --i-taxonomy silva-138.1-ssu-nr99-tax.qza \
    --p-labels Archaea Bacteria Eukaryota \
    --p-min-lens 900 1200 1400 \
    --o-filtered-seqs silva-138.1-ssu-nr99-seqs-filt.qza \
    --o-discarded-seqs silva-138.1-ssu-nr99-seqs-discard.qza 

qiime rescript dereplicate \
    --i-sequences silva-138.1-ssu-nr99-seqs-filt.qza  \
    --i-taxa silva-138.1-ssu-nr99-tax.qza \
    --p-rank-handles 'silva' \
    --p-mode 'uniq' \
    --o-dereplicated-sequences silva-138.1-ssu-nr99-seqs-derep-uniq.qza \
    --o-dereplicated-taxa silva-138.1-ssu-nr99-tax-derep-uniq.qza

qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads  silva-138.1-ssu-nr99-seqs-derep-uniq.qza \
  --i-reference-taxonomy silva-138.1-ssu-nr99-tax-derep-uniq.qza \
  --o-classifier silva-138.1-ssu-nr99-classifier.qza
mv silva-138.1-ssu-nr99-classifier.qza maltecca-piglets/silva-138.1-ssu-nr99-classifier.qza

