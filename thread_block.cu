#include "stdio.h"
#include "stdlib.h"
//#include "conio.h"

__global__ void what_is_my_id(int * block, int * thread, int * wrap, int * calc_thread){
  const int thread_idx = (blockIdx.x * blockDim.x) + threadIdx.x;
  block[thread_idx] = blockIdx.x;
  thread[thread_idx] = threadIdx.x;

  wrap[thread_idx] = threadIdx.x / warpSize;
  calc_thread[thread_idx] = thread_idx;
}

#define ARRAY_SIZE 128
#define ARRAY_SIZE_IN_BYTES (sizeof(unsigned int) * (ARRAY_SIZE))

int cpu_block[ARRAY_SIZE];
int cpu_thread[ARRAY_SIZE];
int cpu_warp[ARRAY_SIZE];
int cpu_calc_thread[ARRAY_SIZE];

int main(void){
  int num_blocks = 2;
  int num_threads = 64;
  //char ch;

  int * gpu_block;
  int * gpu_thread;
  int * gpu_warp;
  int * gpu_calc_thread;

  int i;
  
  cudaMalloc((void **)&gpu_block, ARRAY_SIZE_IN_BYTES);
  cudaMalloc((void **)&gpu_thread, ARRAY_SIZE_IN_BYTES);
  cudaMalloc((void **)&gpu_warp, ARRAY_SIZE_IN_BYTES);
  cudaMalloc((void **)&gpu_calc_thread, ARRAY_SIZE_IN_BYTES);

  what_is_my_id<<<num_blocks, num_threads>>>(gpu_block, gpu_thread, gpu_warp, gpu_calc_thread);
 
  cudaMemcpy(cpu_block, gpu_block, ARRAY_SIZE_IN_BYTES, cudaMemcpyDeviceToHost);
  cudaMemcpy(cpu_thread, gpu_thread, ARRAY_SIZE_IN_BYTES, cudaMemcpyDeviceToHost);
  cudaMemcpy(cpu_warp, gpu_warp, ARRAY_SIZE_IN_BYTES, cudaMemcpyDeviceToHost);
  cudaMemcpy(cpu_calc_thread, gpu_calc_thread, ARRAY_SIZE_IN_BYTES, cudaMemcpyDeviceToHost);

  cudaFree(gpu_block);
  cudaFree(gpu_thread);
  cudaFree(gpu_warp);
  cudaFree(gpu_calc_thread);

  for(i=0;i<ARRAY_SIZE;i++){
     printf("Calculated Thread: %3u - Block: %2u - Warp %2u - Thread %3u\n", cpu_calc_thread[i], cpu_block[i], cpu_warp[i], cpu_thread[i]);
  }
  //ch = getch();
} 
