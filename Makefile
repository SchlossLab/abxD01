################################################################################
#
#	Part 1: Get the reference files
#
#	Here we give instructions on how to get the necessary reference files that
#	are used throughout the rest of the analysis. These are used to calculate
#	error rates, generate alignments, and classify sequences. We will pull down
#	the mock community reference (HMP_MOCK.fasta), the silva reference alignment
#	(silva.bacteria.align), and the RDP training set data (trainset9_032012).
#	Finally, we use the HMP_MOCK.align to get the alignment coordinates for the
#	V4 data. These data will be stored in the data/references/ folder.
#
#	The targets in this part are all used as dependencies in other rules
#
################################################################################

#Location of reference files
REFS = data/references/

#get the silva reference alignment
$(REFS)silva.bacteria.align :
	wget -N -P $(REFS) http://www.mothur.org/w/images/2/27/Silva.nr_v119.tgz; \
	tar xvzf $(REFS)Silva.nr_v119.tgz -C $(REFS);
	mothur "#get.lineage(fasta=$(REFS)silva.nr_v119.align, taxonomy=$(REFS)silva.nr_v119.tax, taxon=Bacteria)";
	mv $(REFS)silva.nr_v119.pick.align $(REFS)silva.bacteria.align; \
	rm $(REFS)README.html; \
	rm $(REFS)README.Rmd; \
	rm $(REFS)silva.nr_v119.*

#get the v4 region of the alignment
$(REFS)silva.v4.align : $(REFS)silva.bacteria.align
	mothur "#pcr.seqs(fasta=$(REFS)silva.bacteria.align, start=11894, end=25319, keepdots=F, processors=8);\
			unique.seqs(fasta=current);"; \
	mv $(REFS)silva.bacteria.pcr.unique.align $(REFS)silva.v4.align; \
	rm $(REFS)silva.bacteria.pcr.*

#get the rdp training set data
$(REFS)trainset10_082014.pds.tax $(REFS)trainset10_082014.pds.fasta :
	wget -N -P $(REFS) http://www.mothur.org/w/images/2/24/Trainset10_082014.pds.tgz; \
	tar xvzf $(REFS)Trainset10_082014.pds.tgz -C $(REFS);\
	mv $(REFS)trainset10_082014.pds/trainset10_082014.* $(REFS);\
	rm -rf $(REFS)trainset10_082014.pds

#get the V4 region of the RDP training set
$(REFS)trainset10_082014.v4.tax $(REFS)trainset10_082014.v4.fasta : \
						$(REFS)trainset10_082014.pds.tax \
						$(REFS)trainset10_082014.pds.fasta \
						$(REFS)silva.v4.align
	mothur "#align.seqs(fasta=$(REFS)trainset10_082014.pds.fasta, reference=$(REFS)silva.v4.align, processors=8);\
		screen.seqs(fasta=current, taxonomy=$(REFS)trainset10_082014.pds.tax, start=1968, end=11550);\
		degap.seqs(fasta=current)"; \
	mv $(REFS)trainset10_082014.pds.good.ng.fasta $(REFS)trainset10_082014.v4.fasta; \
	mv $(REFS)trainset10_082014.pds.good.tax $(REFS)trainset10_082014.v4.tax;\
	rm data/references/trainset10_082014.pds.align*;\
	rm data/references/trainset10_082014.pds.bad.accnos;\
	rm data/references/trainset10_082014.pds.flip.accnos;

$(REFS)HMP_MOCK.fasta :
	wget --no-check-certificate -N -P $(REFS) https://raw.githubusercontent.com/SchlossLab/Kozich_MiSeqSOP_AEM_2013/master/data/references/HMP_MOCK.fasta

#align the mock community reference sequeces
$(REFS)HMP_MOCK.v4.fasta : $(REFS)HMP_MOCK.fasta $(REFS)silva.v4.align
	mothur "#align.seqs(fasta=$(REFS)HMP_MOCK.fasta, reference=$(REFS)silva.v4.align);\
			degap.seqs()";\
	mv $(REFS)HMP_MOCK.ng.fasta $(REFS)HMP_MOCK.v4.fasta;\
	rm $(REFS)HMP_MOCK.align;\
	rm $(REFS)HMP_MOCK.align.report;\
	rm $(REFS)HMP_MOCK.flip.accnos


################################################################################
#
#	Part 2: Run data through mothur
#
#
################################################################################

# build the files file. probably should replace this chunk eventually
# with pulling data off of the SRA
data/process/abxD0.files : code/make_files_file.R data/process/abx_cdiff_metadata.tsv
	R -e "source('code/make_files_file.R')"


# need to get the fastq files. probably should replace this chunk eventually
# with pulling data off of the SRA
data/raw/get_data : code/get_fastqs.sh data/process/abxD0.files
	bash code/get_fastqs.sh data/process/abxD0.files;\
	touch data/raw/get_data

BASIC_STEM = data/process/abxD0.trim.contigs.good.unique.good.filter.unique.precluster


# need to get the CFU on the day after antibiotic treatment along with the
# part of the experiment that each sample belongs to

data/process/abxD1.counts : code/make_counts_file.R data/process/abxD0.files\
							data/process/abx_cdiff_metadata.tsv
	R -e "source('code/make_counts_file.R')"


# here we go from the raw fastq files and the files file to generate a fasta,
# taxonomy, and count_table file that has had the chimeras removed as well as
# any non bacterial sequences
$(BASIC_STEM).uchime.pick.pick.count_table $(BASIC_STEM).pick.pick.fasta $(BASIC_STEM).pick.v4.wang.pick.taxonomy : code/get_good_seqs.batch\
										data/raw/get_data\
										data/references/silva.v4.align\
										data/references/trainset10_082014.v4.fasta\
										data/references/trainset10_082014.v4.tax
	mothur code/get_good_seqs.batch;\
	rm data/process/*.map



# here we go from the good sequences and generate a shared file and a
# cons.taxonomy file based on OTU data
$(BASIC_STEM).pick.pick.pick.an.unique_list.shared $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.cons.taxonomy : code/get_shared_otus.batch\
										$(BASIC_STEM).uchime.pick.pick.count_table\
										$(BASIC_STEM).pick.pick.fasta\
										$(BASIC_STEM).pick.v4.wang.pick.taxonomy
	mothur code/get_shared_otus.batch;\
	rm data/process/abxD0.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.pick.count_table;\
	rm data/process/abxD0.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.fasta;\
	rm data/process/abxD0.trim.contigs.good.unique.good.filter.unique.precluster.pick.v4.wang.pick.pick.taxonomy;\
	rm data/process/*.an.*rabund



# here we go from the good sequences and generate a shared file and a
# cons.taxonomy file based on phylum-level data
$(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.cons.taxonomy $(BASIC_STEM).pick.v4.wang.pick.pick.tx.shared : code/get_shared_phyla.batch\
										$(BASIC_STEM).uchime.pick.pick.count_table\
										$(BASIC_STEM).pick.pick.fasta\
										$(BASIC_STEM).pick.v4.wang.pick.taxonomy
	mothur code/get_shared_phyla.batch;\
	rm data/process/abxD0.trim.contigs.good.unique.good.filter.unique.precluster.uchime.pick.pick.pick.count_table;\
	rm data/process/abxD0.trim.contigs.good.unique.good.filter.unique.precluster.pick.pick.pick.fasta;\
	rm data/process/abxD0.trim.contigs.good.unique.good.filter.unique.precluster.pick.v4.wang.pick.pick.taxonomy;\
	rm data/process/*.tx.*rabund;


# now we want to get the sequencing error as seen in the mock community samples
$(BASIC_STEM).pick.pick.pick.error.summary : code/get_error.batch\
										$(BASIC_STEM).uchime.pick.pick.count_table\
										$(BASIC_STEM).pick.pick.fasta\
										$(REFS)HMP_MOCK.v4.fasta
	mothur code/get_error.batch


# rarefy the number of reads to 1625 sequences per library for the alpha and beta diversity analyses and modeling
$(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.subsample.shared $(BASIC_STEM).pick.pick.pick.an.unique_list.groups.ave-std.summary $(BASIC_STEM).pick.pick.pick.an.unique_list.thetayc.0.03.lt.ave.dist : $(BASIC_STEM).pick.pick.pick.an.unique_list.shared
	mothur "#dist.shared(shared=$^, calc=thetayc, subsample=1625, iters=100); summary.single(shared=$^, subsample=1625, calc=nseqs-sobs-shannon-invsimpson, iters=100); sub.sample(shared=$^, size=1625)";\
	rm $(BASIC_STEM).pick.pick.pick.an.unique_list.groups.summary;\
	rm $(BASIC_STEM).pick.pick.pick.an.unique_list.thetayc.0.03.lt.dist;\
	rm $(BASIC_STEM).pick.pick.pick.an.unique_list.thetayc.0.03.lt.std.dist;\
	rm $(BASIC_STEM).pick.pick.pick.an.unique_list.*.rabund

# rarefy the number of reads to 1625 sequences per library for the barcarts
$(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.subsample.shared : $(BASIC_STEM).pick.v4.wang.pick.pick.tx.shared
		mothur "#sub.sample(shared=$^, size=1625)";


# let's do the amova analysis using the top dose samples
data/process/abx_topdose.design $(BASIC_STEM).pick.pick.pick.an.unique_list.topdose.shared : data/process/abxD1.counts $(BASIC_STEM).pick.pick.pick.an.unique_list.shared code/prep_for_top_dose_amova.R
	R -e "source('code/prep_for_top_dose_amova.R')"

$(BASIC_STEM).pick.pick.pick.an.unique_list.topdose.thetayc.0.03.lt.ave.amova : data/process/abx_topdose.design $(BASIC_STEM).pick.pick.pick.an.unique_list.topdose.shared code/run_shared_to_amova.batch
	mothur code/run_shared_to_amova.batch



################################################################################
#
#	Part 3: Write the paper
#
################################################################################

results/figures/figure1.tiff : code/build_figure1.R $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.subsample.shared $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.cons.taxonomy data/process/abxD1.counts
	R -e "source('code/build_figure1.R')"

results/figures/figure2.tiff : code/build_figure2.R $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.subsample.shared $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.cons.taxonomy data/process/abxD1.counts
	R -e "source('code/build_figure2.R')"

results/figures/figure3.tiff : code/build_figure3.R $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.subsample.shared $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.cons.taxonomy data/process/abxD1.counts
	R -e "source('code/build_figure3.R')"

results/figures/figure4.tiff data/process/correlation_analysis.tsv : code/build_figure4.R $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.subsample.shared $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.cons.taxonomy data/process/abxD1.counts
	R -e "source('code/build_figure4.R')"

results/figures/figure5.tiff results/figures/figure6.tiff results/figures/figureS4.tiff data/process/random_forest.data : code/build_figure5_6_S4.R $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.subsample.shared $(BASIC_STEM).pick.pick.pick.an.unique_list.0.03.cons.taxonomy data/process/abxD1.counts data/process/correlation_analysis.tsv
	R -e "source('code/build_figure5_6_S4.R')"

results/figures/figureS1.tiff : code/build_figureS1.R $(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.subsample.shared $(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.cons.taxonomy data/process/abxD1.counts
			R -e "source('code/build_figureS1.R')"

results/figures/figureS2.tiff : code/build_figureS2.R $(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.subsample.shared $(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.cons.taxonomy data/process/abxD1.counts
		R -e "source('code/build_figureS2.R')"

results/figures/figureS3.tiff : code/build_figureS3.R $(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.subsample.shared $(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.cons.taxonomy data/process/abxD1.counts
	R -e "source('code/build_figureS3.R')"



write.paper : $(BASIC_STEM).pick.pick.pick.an.unique_list.topdose.thetayc.0.03.lt.ave.amova\
				$(BASIC_STEM).pick.pick.pick.an.unique_list.groups.ave-std.summary\
				data/process/abxD1.counts\
				$(BASIC_STEM).pick.pick.pick.error.summary\
				$(BASIC_STEM).pick.v4.wang.pick.pick.tx.5.subsample.shared\
				data/process/random_forest.data\
				data/process/correlation_analysis.tsv\
				results/figures/figure1.tiff\
				results/figures/figure2.tiff\
				results/figures/figure3.tiff\
				results/figures/figure4.tiff\
				results/figures/figure5.tiff\
				results/figures/figure6.tiff\
				results/figures/figureS1.tiff\
				results/figures/figureS2.tiff\
				results/figures/figureS3.tiff\
				results/figures/figureS4.tiff
	R -e "library(knitr);knit2html('Schubert_abxD01_mBio_2015.Rmd', 'Schubert_abxD01_mBio_2015.html')"
	pandoc -f markdown -t docx Schubert_abxD01_mBio_2015.md -o Schubert_abxD01_mBio_2015.docx
