#!/bin/bash -x
#
#PJM --rsc-list "rscgrp=short"
#PJM --rsc-list "node=10"
#PJM --rsc-list "elapse=00:20:00"
#PJM --mpi "proc=160"
#PJM -s
#PJM -m "e"
#


NRNIV="../../../neuron_kplus/specials/sparc64/special -mpi"
HOC_NAME="./network.hoc"

LPG="lpgparm -t 4MB -s 4MB -d 4MB -p 4MB"
MPIEXEC="mpiexec -mca mpi_print_stats 1"
PROF=""
echo "${PROF} ${MPIEXEC} ${LPG} ${NRNIV} ${HOC_NAME}"
time ${PROG} ${MPIEXEC} ${LPG} ${NRNIV} ${HOC_NAME}

sync