#include <stdio.h>
#include <time.h>
#include <unistd.h>

#define PARENT_NUM 16
#define CHILD_NUM 256
#define BRANCH_NUM 20

int main(int argc, char** argv){
  int child, branch;
  int i,j;
  int order[BRANCH_NUM][PARENT_NUM];
  int buf[PARENT_NUM], order_buf[PARENT_NUM];
  int counter=0;
  FILE *fp;

  srand((unsigned)time(NULL));
  //iterate CHILD_NUM times
  for(child=0;child<CHILD_NUM;child++){
    //initialize
    for(i=0;i<BRANCH_NUM;i++){
      for(j=0;j<PARENT_NUM;j++){
	order[i][j] = -1;
      }
    }
    
    for(branch=0;branch<BRANCH_NUM;branch++){
      for(i=0;i<PARENT_NUM;i++){
	buf[i] = rand()%200;
      }
      
      for(i=0;i<PARENT_NUM;i++){
	for(j=0;j<PARENT_NUM;j++){
	  if(i==j){
	    continue;
	  }else{
	    if(buf[i]<buf[j]){
	      counter++;
	    }
	  }
	}
	order[branch][i] = counter;
	counter = 0;
      }
    }
    if((fp=fopen("con_orderlist.dat","a+"))==NULL){
      printf("file open error\n");
      return -1;
    }

    for(i=0;i<BRANCH_NUM;i++){
      for(j=0;j<PARENT_NUM;j++){
	fprintf(fp,"%d\t",order[i][j]);
      }
      fprintf(fp,"\n");
    }
    fclose(fp);
  }
  return 0;
}
  
