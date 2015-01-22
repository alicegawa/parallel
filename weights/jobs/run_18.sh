#!/bin/bash -x
#
#PJM --rsc-list "rscgrp=short"
#PJM --rsc-list "node=10"
#PJM --rsc-list "elapse=01:00:00"
#PJM --mpi "proc=160"
#PJM --stg-transfiles all
#PJM --mpi "use-rankdir"

#PJM --stgin "rank=* ./* %r:./"
#PJM --stgin "rank=* ./data/* %r:./data/"
#PJM --stgin "rank=* ./weights/* %r:./weights/"
#PJM --stgin "rank=* ./result/* %r:./result/"
#PJM --stgin "rank=* ./change/* %r:./change/"

#PJM --stgin "rank=* /home/e16005/neuron_kplus/specials/sparc64/special %r:./"

#PJM --stgout "rank=* %r:./result/* /group/gh16/e16005/0108/result/sw/%j/"
#PJM --stgout "rank=* %r:./change/* /group/gh16/e16005/0108/change/sw/%j/"

#PJM -s
#PJM -m "e"
#


#NRNIV="../../../neuron_kplus/specials/sparc64/special -mpi"
NRNIV="./special -mpi"
HOC_NAME="./network.hoc"

NRNOPT=\
" -c OUT1_E=0.001"\
" -c OUT1_I=0.03"\
" -c IO_E=0.002"\
" -c IO_I2E=0.0015"\
" -c IO_I2I=0.001"\
" -c OUT1_SPON_E_K=0.15"\
" -c OUT1_SPON_E_T=0.35"\
" -c DOPAMINE=0.01"\
" -c LEARNING_RATE=0.00015"\
" -c OUT1_SPON_I_K=0.15"\
" -c OUT1_SPON_I_T=0.3"\
" -c LTD=0.7"


LPG="lpgparm -t 4MB -s 4MB -d 4MB -p 4MB"
MPIEXEC="mpiexec -mca mpi_print_stats 1"
PROF=""
echo "${PROF} ${MPIEXEC} ${LPG} ${NRNIV} ${HOC_NAME}"
time ${PROG} ${MPIEXEC} ${LPG} ${NRNIV} ${NRNOPT} ${HOC_NAME}

sync