#include "stdio.h"

__global__ void kernel(void){
}

int main(void){
  kernel<<<1,2>>>();
  printf("Hello, World!\n");
  return 0;
}

