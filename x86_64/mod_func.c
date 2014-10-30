#include <stdio.h>
#include "hocdec.h"
extern int nrnmpi_myid;
extern int nrn_nobanner_;

extern void _gamma_reg(void);
extern void _stdp_reg(void);

void modl_reg(){
  if (!nrn_nobanner_) if (nrnmpi_myid < 1) {
    fprintf(stderr, "Additional mechanisms from files\n");

    fprintf(stderr," mod//gamma.mod");
    fprintf(stderr," mod//stdp.mod");
    fprintf(stderr, "\n");
  }
  _gamma_reg();
  _stdp_reg();
}
