#include <stdio.h>
#include <cuda.h>

#define N 32

//  thread with laneId 31 will have the final sum value
__global__ void findSum(const int n, int* arr){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    register int value = arr[i];
    int laneId = threadIdx.x & 0xffffffff;
    int completed = 0;
    for(int i = 16; i >= 1; i /= 2){
        completed += i;
        int down_value = __shfl_up_sync(0xffffffff, value, i);
        if(laneId >= completed) value += down_value; 
    }
    printf("threadId = %d, blockId = %d, value = %d\n", threadIdx.x, blockIdx.x, value);
}

__global__ void initialize_arr(const int n, int* arr){
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    arr[i] = i;
}

int main(){
    int* d_arr;
    cudaMalloc(&d_arr, N*sizeof(int));
    initialize_arr <<< 1, 32 >>> (N, d_arr);
    findSum <<< 1, 32 >>> (N, d_arr);
    cudaDeviceSynchronize();

    return 0;
}