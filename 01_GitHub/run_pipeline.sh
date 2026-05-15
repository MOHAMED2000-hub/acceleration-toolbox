#!/bin/bash
set -euo pipefail

echo "Starting workshop pipeline"

#################################################
# GROUP 1 SECTION
#################################################

bash scripts/qc.sh

#################################################
# GROUP 2 SECTION
#################################################

bash scripts/annotation.sh

#################################################
# GROUP 3 SECTION
#################################################

bash scripts/build_report.sh

echo "Pipeline completed"