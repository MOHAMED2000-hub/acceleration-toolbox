#!/bin/bash
set -euo pipefail

mkdir -p website/assets

cp results/amr/amr_summary.tsv website/assets/
cp results/qc/multiqc/multiqc_report.html website/assets/

echo "Report assets copied"