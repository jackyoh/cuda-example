#include "stdio.h"

int main(void){
   cudaDeviceProp prop;
   int count;
   cudaGetDeviceCount(&count);

   for(int i = 0 ; i < count ; i++){
     cudaGetDeviceProperties(&prop, i);
     printf("Name: %s\n", prop.name);
     printf("Compute capability: %d.%d\n", prop.major, prop.minor);
     printf("Clock rate: %d\n", prop.clockRate);
     printf("Total global mem: %d\n", prop.totalGlobalMem);
     printf("Max threads per block: %d\n",prop.maxThreadsPerBlock);


   }

}
