#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "MT.h"

#define NCELL 100
#define NCON 10
#define NCELL_E 80
#define NSYN_MAX (NCELL-1)*NCON

int main(int argc, char **argv){
  FILE *fp;
  int i,j;
  int r;
  int table[NCELL][NCON];
  int output[NCELL][NSYN_MAX], counter[NCELL];
  srand((unsigned)time(NULL));
  if((fp=fopen("con.dat","w"))==NULL){
    printf("file open error\n");
    exit(EXIT_FAILURE);
  }

  for(i=0;i<NCELL;i++){
    for(j=0;j<NSYN_MAX;j++){
      output[i][j] = -1;
    }
    counter[i] = 0;
  }

  for(i=0;i<NCELL;i++){
    for(j=0;j<NCON;j++){
      if(i<NCELL_E){
	r = (i+(1+rand()%(NCELL-1)))%NCELL;
      }else{
	r = rand()%NCELL_E;
      }
      output[r][counter[r]] = i;
      counter[r]++;
    }
  }
  for(i=0;i<NCELL;i++){
    if(counter[i]==0){
      output[i][counter[i]] = rand()%NCELL_E;
      counter[i]++;
    }
  }
  
  for(i=0;i<NCELL;i++){
    for(j=0;j<NSYN_MAX;j++){
      if(output[i][j]!=-1){
	fprintf(fp,"%d\t",output[i][j]);
      }
    }
    fprintf(fp,"\n");
  }
  fclose(fp);
  return 0;
}
