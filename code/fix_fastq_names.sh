#!/bin/bash

################################################################################
#
# fix_fastq_names.sh
#
# Coming off the sequencer, the fastq file names were pretty inconsistent. This
# script renames the fastq files. It was run on the fastq files prior to moving
# the files into the data/raw folder.
#
################################################################################


#touch $(cat fastq.files)


# if a file name starts with a single number followed by a dash, add two zeros to the front
for F in $(ls ?-*.fastq)
do
	PREFIXED=$(echo $F | sed 's/^\([0-9]\)-/00\1-/')
	mv $F $PREFIXED
done


# if a file name starts with two numbers followed by a dash, add one zero to the front
for F in $(ls ??-*.fastq)
do
	PREFIXED=$(echo $F | sed 's/^\([0-9][0-9]\)-/0\1-/')
	mv $F $PREFIXED
done


#if the animal number is surrounded by dashes, remove the second dash
for F in $(ls *-?-*.fastq)
do
	DEDASHED=$(echo $F | sed 's/^\(.*-[0-9]\)-\(.*\)/\1\2/')
	mv $F $DEDASHED
done

mv 81D1_S122_L001_R1_001.fastq 008-1D1_S122_L001_R1_001.fastq
mv 81D1_S122_L001_R2_001.fastq 008-1D1_S122_L001_R2_001.fastq
mv 71D1_S118_L001_R1_001.fastq 007-1D1_S118_L001_R1_001.fastq
mv 71D1_S118_L001_R2_001.fastq 007-1D1_S118_L001_R2_001.fastq

mv 357D-1_S106_L001_R1_001.fastq 007-357D-1_S106_L001_R1_001.fastq
mv 357D-1_S106_L001_R2_001.fastq 007-357D-1_S106_L001_R2_001.fastq
mv 357D-6_S99_L001_R1_001.fastq 007-357D-6_S99_L001_R1_001.fastq
mv 357D-6_S99_L001_R2_001.fastq 007-357D-6_S99_L001_R2_001.fastq
mv 357D0_S113_L001_R1_001.fastq 007-357D0_S113_L001_R1_001.fastq
mv 357D0_S113_L001_R2_001.fastq 007-357D0_S113_L001_R2_001.fastq
mv 357D10_S181_L001_R1_001.fastq 007-357D10_S181_L001_R1_001.fastq
mv 357D10_S181_L001_R2_001.fastq 007-357D10_S181_L001_R2_001.fastq
mv 357D1_S120_L001_R1_001.fastq 007-357D1_S120_L001_R1_001.fastq
mv 357D1_S120_L001_R2_001.fastq 007-357D1_S120_L001_R2_001.fastq
mv 357D2_S127_L001_R1_001.fastq 007-357D2_S127_L001_R1_001.fastq
mv 357D2_S127_L001_R2_001.fastq 007-357D2_S127_L001_R2_001.fastq
mv 357D3_S134_L001_R1_001.fastq 007-357D3_S134_L001_R1_001.fastq
mv 357D3_S134_L001_R2_001.fastq 007-357D3_S134_L001_R2_001.fastq
mv 357D4_S141_L001_R1_001.fastq 007-357D4_S141_L001_R1_001.fastq
mv 357D4_S141_L001_R2_001.fastq 007-357D4_S141_L001_R2_001.fastq
mv 357D5_S147_L001_R1_001.fastq 007-357D5_S147_L001_R1_001.fastq
mv 357D5_S147_L001_R2_001.fastq 007-357D5_S147_L001_R2_001.fastq
mv 357D6_S153_L001_R1_001.fastq 007-357D6_S153_L001_R1_001.fastq
mv 357D6_S153_L001_R2_001.fastq 007-357D6_S153_L001_R2_001.fastq
mv 357D7_S160_L001_R1_001.fastq 007-357D7_S160_L001_R1_001.fastq
mv 357D7_S160_L001_R2_001.fastq 007-357D7_S160_L001_R2_001.fastq
mv 357D8_S167_L001_R1_001.fastq 007-357D8_S167_L001_R1_001.fastq
mv 357D8_S167_L001_R2_001.fastq 007-357D8_S167_L001_R2_001.fastq
mv 357D8_S168_L001_R1_001.fastq 007-357D8_S168_L001_R1_001.fastq
mv 357D8_S168_L001_R2_001.fastq 007-357D8_S168_L001_R2_001.fastq
mv 357D9_S174_L001_R1_001.fastq 007-357D9_S174_L001_R1_001.fastq
mv 357D9_S174_L001_R2_001.fastq 007-357D9_S174_L001_R2_001.fastq
mv 358D-1_S107_L001_R1_001.fastq 007-358D-1_S107_L001_R1_001.fastq
mv 358D-1_S107_L001_R2_001.fastq 007-358D-1_S107_L001_R2_001.fastq
mv 358D-6_S100_L001_R1_001.fastq 007-358D-6_S100_L001_R1_001.fastq
mv 358D-6_S100_L001_R2_001.fastq 007-358D-6_S100_L001_R2_001.fastq
mv 358D0_S114_L001_R1_001.fastq 007-358D0_S114_L001_R1_001.fastq
mv 358D0_S114_L001_R2_001.fastq 007-358D0_S114_L001_R2_001.fastq
mv 358D10_S182_L001_R1_001.fastq 007-358D10_S182_L001_R1_001.fastq
mv 358D10_S182_L001_R2_001.fastq 007-358D10_S182_L001_R2_001.fastq
mv 358D1_S121_L001_R1_001.fastq 007-358D1_S121_L001_R1_001.fastq
mv 358D1_S121_L001_R2_001.fastq 007-358D1_S121_L001_R2_001.fastq
mv 358D2_S128_L001_R1_001.fastq 007-358D2_S128_L001_R1_001.fastq
mv 358D2_S128_L001_R2_001.fastq 007-358D2_S128_L001_R2_001.fastq
mv 358D3_S135_L001_R1_001.fastq 007-358D3_S135_L001_R1_001.fastq
mv 358D3_S135_L001_R2_001.fastq 007-358D3_S135_L001_R2_001.fastq
mv 358D5_S148_L001_R1_001.fastq 007-358D5_S148_L001_R1_001.fastq
mv 358D5_S148_L001_R2_001.fastq 007-358D5_S148_L001_R2_001.fastq
mv 358D6_S154_L001_R1_001.fastq 007-358D6_S154_L001_R1_001.fastq
mv 358D6_S154_L001_R2_001.fastq 007-358D6_S154_L001_R2_001.fastq
mv 358D7_S161_L001_R1_001.fastq 007-358D7_S161_L001_R1_001.fastq
mv 358D7_S161_L001_R2_001.fastq 007-358D7_S161_L001_R2_001.fastq
mv 358D8_S192_L001_R1_001.fastq 007-358D8_S192_L001_R1_001.fastq
mv 358D8_S192_L001_R2_001.fastq 007-358D8_S192_L001_R2_001.fastq
mv 358D9_S175_L001_R1_001.fastq 007-358D9_S175_L001_R1_001.fastq
mv 358D9_S175_L001_R2_001.fastq 007-358D9_S175_L001_R2_001.fastq
mv 362D-1_S110_L001_R1_001.fastq 008-362D-1_S110_L001_R1_001.fastq
mv 362D-1_S110_L001_R2_001.fastq 008-362D-1_S110_L001_R2_001.fastq
mv 362D-6_S103_L001_R1_001.fastq 008-362D-6_S103_L001_R1_001.fastq
mv 362D-6_S103_L001_R2_001.fastq 008-362D-6_S103_L001_R2_001.fastq
mv 362D0_S117_L001_R1_001.fastq 008-362D0_S117_L001_R1_001.fastq
mv 362D0_S117_L001_R2_001.fastq 008-362D0_S117_L001_R2_001.fastq
mv 362D10_S185_L001_R1_001.fastq 008-362D10_S185_L001_R1_001.fastq
mv 362D10_S185_L001_R2_001.fastq 008-362D10_S185_L001_R2_001.fastq
mv 362D1_S124_L001_R1_001.fastq 008-362D1_S124_L001_R1_001.fastq
mv 362D1_S124_L001_R2_001.fastq 008-362D1_S124_L001_R2_001.fastq
mv 362D2_S131_L001_R1_001.fastq 008-362D2_S131_L001_R1_001.fastq
mv 362D2_S131_L001_R2_001.fastq 008-362D2_S131_L001_R2_001.fastq
mv 362D3_S138_L001_R1_001.fastq 008-362D3_S138_L001_R1_001.fastq
mv 362D3_S138_L001_R2_001.fastq 008-362D3_S138_L001_R2_001.fastq
mv 362D4_S144_L001_R1_001.fastq 008-362D4_S144_L001_R1_001.fastq
mv 362D4_S144_L001_R2_001.fastq 008-362D4_S144_L001_R2_001.fastq
mv 362D6_S157_L001_R1_001.fastq 008-362D6_S157_L001_R1_001.fastq
mv 362D6_S157_L001_R2_001.fastq 008-362D6_S157_L001_R2_001.fastq
mv 362D7_S164_L001_R1_001.fastq 008-362D7_S164_L001_R1_001.fastq
mv 362D7_S164_L001_R2_001.fastq 008-362D7_S164_L001_R2_001.fastq
mv 362D8_S171_L001_R1_001.fastq 008-362D8_S171_L001_R1_001.fastq
mv 362D8_S171_L001_R2_001.fastq 008-362D8_S171_L001_R2_001.fastq
mv 362D9_S178_L001_R1_001.fastq 008-362D9_S178_L001_R1_001.fastq
mv 362D9_S178_L001_R2_001.fastq 008-362D9_S178_L001_R2_001.fastq

#mv mock1_S26_L001_R1_001.fastq mock1_S26_L001_R1_001.fastq
#mv mock1_S26_L001_R1_001.fastq mock1_S26_L001_R2_001.fastq
#mv mock2_S27_L001_R1_001.fastq mock2_S27_L001_R1_001.fastq
#mv mock2_S27_L001_R2_001.fastq mock2_S27_L001_R2_001.fastq
mv mock_S192_L001_R1_001.fastq mock3_S192_L001_R1_001.fastq
mv mock_S192_L001_R2_001.fastq mock3_S192_L001_R2_001.fastq
mv mock_S357_L001_R1_001.fastq mock4_S357_L001_R1_001.fastq
mv mock_S357_L001_R2_001.fastq mock4_S357_L001_R2_001.fastq
mv mock_S96_L001_R1_001.fastq mock5_S96_L001_R1_001.fastq
mv mock_S96_L001_R2_001.fastq mock5_S96_L001_R2_001.fastq
mv Mock_S287_L001_R1_001.fastq mock6_S287_L001_R1_001.fastq
mv Mock_S287_L001_R2_001.fastq mock6_S287_L001_R2_001.fastq
mv Mock_S288_L001_R1_001.fastq mock7_S288_L001_R1_001.fastq
mv Mock_S288_L001_R2_001.fastq mock7_S288_L001_R2_001.fastq
mv Mock_S384_L001_R1_001.fastq mock8_S384_L001_R1_001.fastq
mv Mock_S384_L001_R2_001.fastq mock8_S384_L001_R2_001.fastq
mv Mock_S192_L001_R1_001.fastq mock9_S192_L001_R1_001.fastq
mv Mock_S192_L001_R2_001.fastq mock9_S192_L001_R2_001.fastq


#this counts the number of fastq files from each animal/cage combination
ls *fastq | cut -f 1 -d "D" | sort | uniq -c
