#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "MT.h"

#define NCELL 100
#define NCON 10
#define NCELL_E 80
#define NSYN_MAX (NCELL-1)*NCON
#define MDIM (int)(sqrt(NCELL))
int main(int argc, char **argv){
  FILE *fp;
  int i,j;
  int r;
  int counter[NCELL];
  int output[NCELL][NCELL],col=0,row=0;

  srand((unsigned)time(NULL));
  for(i=0;i<NCELL;i++){
    for(j=0;j<NCELL;j++){
      output[i][j]=0;
    }
  }
  
  for(i=0;i<MDIM;i++){
    for(j=0;j<MDIM;j++){
      if(i){
	output[i*MDIM+j][(i-1)*MDIM+j]=1;
	if(i>=2){
	output[i*MDIM+j][(i-2)*MDIM+j]=2;
	}
      }
      if(i<=(MDIM-2)){
	output[i*MDIM+j][(i+1)*MDIM+j]=1;
	if(i<=(MDIM-3)){
	  output[i*MDIM+j][(i+2)*MDIM+j]=2;
	}
      }
      if(j){
	output[i*MDIM+j][i*MDIM+(j-1)]=1;
	if(j>=2){
	  output[i*MDIM+j][i*MDIM+(j-2)]=2;
	}
      }
      if(j<=(MDIM-2)){
	output[i*MDIM+j][i*MDIM+(j+1)]=1;
	if(j<=(MDIM-3)){
	  output[i*MDIM+j][i*MDIM+(j+2)]=2;
	}
      }
    }
  }
  for(i=0;i<NCELL;i++){
    for(j=0;j<NCELL;j++){
      //if(i==0 || i==45 || i==50 || i==90 || i==99){
	if(j%10==0){
	  printf("\n");
	}
	printf("%d ",output[i][j]);
	//}
    }
    printf("\n");
  }

  if((fp=fopen("con_var.dat","w"))==NULL){
    printf("file open error\n");
    exit(EXIT_FAILURE);
  }
  for(i=0;i<NCELL;i++){
    for(j=0;j<NCELL;j++){
      fprintf(fp,"%d\t",output[i][j]);
      //printf("%d\t",output[i][j]);
    }
    fprintf(fp,"\n");
    printf("\n");
  }
  fclose(fp);

  return 0;
}
