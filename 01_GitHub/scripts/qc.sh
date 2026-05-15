#!/bin/bash
set -euo pipefail

mkdir -p results/qc/raw
mkdir -p results/qc/trimmed

echo "Running FastQC on raw reads"

fastqc data/raw/*.fastq.gz \
    --outdir results/qc/raw

echo "Running Cutadapt"

for R1 in data/raw/*_R1.fastq.gz; do

    SAMPLE=$(basename "$R1" _R1.fastq.gz)

    cutadapt \
        -a AGATCGGAAGAGC \
        -A AGATCGGAAGAGC \
        -o results/qc/trimmed/${SAMPLE}_R1.trimmed.fastq.gz \
        -p results/qc/trimmed/${SAMPLE}_R2.trimmed.fastq.gz \
        data/raw/${SAMPLE}_R1.fastq.gz \
        data/raw/${SAMPLE}_R2.fastq.gz

done

echo "Running FastQC on trimmed reads"

fastqc results/qc/trimmed/*.fastq.gz \
    --outdir results/qc/trimmed

echo "Generating MultiQC report"

multiqc results/qc \
    --outdir results/qc/multiqc

echo "QC pipeline complete"