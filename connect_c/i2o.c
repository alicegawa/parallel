#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#define NCELL 400//100
#define PARENT 256
#define NCON 40//10
#define NSYN_MAX 4000//1000
#define MDIM sqrt(NCELL)

int main(int argc, char** argv){
  FILE *fp;
  int i,j;
  int r;
  srand((unsigned)time(NULL));
  int output[NCELL][NSYN_MAX], counter[NCELL];
  int output2[NCELL][PARENT], col=0, row=0;

  if((fp=fopen("con_i2o1.dat","w"))==NULL){
    printf("file open error\n");
    return -1;
  }

   for(i=0;i<NCELL;i++){
    for(j=0;j<NSYN_MAX;j++){
      output[i][j] = -1;
    }
    counter[i] = 0;
  }

  for(i=0;i<PARENT;i++){
    for(j=0;j<NCON;j++){
      r = (i+(1+rand()%(NCELL-1)))%NCELL;
      output[r][counter[r]] = i;
      counter[r]++;
    }
  }
  for(i=0;i<NCELL;i++){
    if(counter[i]==0){
      output[i][counter[i]] = rand()%NCELL;
      counter[i]++;
    }
  }

  for(i=0;i<NCELL;i++){
    for(j=0;j<PARENT;j++){
      output2[i][j]=0;
    }
  }
  for(i=0;i<NCELL;i++){
    for(j=0;j<NSYN_MAX;j++){
      if(output[i][j]!=-1){
	output2[i][output[i][j]]++;
	printf("%d\t",output[i][j]);
      }
    }    
    printf("\n");
  }
  
  //below this, file output section
  for(i=0;i<NCELL;i++){
    for(j=0;j<NSYN_MAX;j++){
      if(output[i][j]!=-1){
	fprintf(fp,"%d\t",output[i][j]);
      }
    }
    fprintf(fp,"\n");
  }
  fclose(fp);
  if((fp=fopen("con_var_i2o1.dat","w"))==NULL){
    printf("file open error\n");
    exit(EXIT_FAILURE);
  }
  printf("where is core dump?\n");
  for(i=0;i<NCELL;i++){
    for(j=0;j<PARENT;j++){
      fprintf(fp,"%d\t",output2[i][j]);
      printf("%d\t",output2[i][j]);
    }
    fprintf(fp,"\n");
    printf("\n");
  }
  fclose(fp);

  return 0;
}

  
