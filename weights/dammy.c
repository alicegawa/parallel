#include <stdio.h>

int main()
{
  FILE *fp;
  int i;
  if((fp=fopen("nclist0.dat","w"))==NULL){
    printf("errro\n");
    return -1;
  }
  for(i=0;i<8480;i++){
    fprintf(fp,"0\t");
  }
  fclose(fp);

  if((fp=fopen("nclist_out2_1.dat","w"))==NULL){
    printf("error\n");
    return -1;
  }

  for(i=0;i<482;i++){
    fprintf(fp,"0\t");
  }
  fclose(fp);
  return 0;
}
