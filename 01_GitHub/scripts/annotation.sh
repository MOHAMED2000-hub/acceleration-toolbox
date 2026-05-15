#!/bin/bash
set -euo pipefail

mkdir -p results/amr

echo "Running AMR annotation"

blastn \
    -query data/amr_db/test_sequences.fasta \
    -db data/amr_db/amr_database.fasta \
    -out results/amr/amr_hits.tsv \
    -outfmt 6

echo "Summarizing hits"

awk '
{
    counts[$2]++
}
END{
    print "Gene\tHits"
    for (g in counts)
        print g "\t" counts[g]
}
' results/amr/amr_hits.tsv \
> results/amr/amr_summary.tsv

echo "AMR annotation complete"