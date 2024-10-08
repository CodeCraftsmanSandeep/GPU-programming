#include <stdio.h>
#include <cuda.h>
#define FULL_MASK 0xffffffff

__global__ void find_sum(const int start, const int end, const float* arr, float* result){
    const int index = threadIdx.x + start;
    register float value = 0.f;
    const int laneId = threadIdx.x % 32;
    const int n = end - start + 1;
        
    // handle last n%32 elements seperately
    if(threadIdx.x >= n / 32 * 32){
        if(laneId == 0) for(int i = index; i <= end; i++) value += arr[i];
    }else{
        value = arr[index];
        for(int offset = 16; offset >= 1; offset /= 2) value += __shfl_down_sync(FULL_MASK, value, offset);
    }

    __shared__ float blockSum;
    if(threadIdx.x == 0) blockSum = 0.0f;
    __syncthreads();
    if(laneId == 0) atomicAdd(&blockSum, value);
    __syncthreads();
    if(threadIdx.x == 0) *result = blockSum;
}

#define N 1024

__global__ void parent_kernel(const float* arr, float* res){
    const int start = 20;
    const int end = 1023;
    if(blockIdx.x == 0 && threadIdx.x == 0) find_sum <<< 1, end - start + 1 >>> (start, end, arr, res + 1);
}

int main(){
    float* arr = (float*)malloc(N * sizeof(float));
    for(int i = 0; i < N; i++) arr[i] = 1;
    // arr[100] = -1;

    float* d_arr;
    cudaMalloc(&d_arr, N * sizeof(float));
    cudaMemcpy(d_arr, arr, N * sizeof(float), cudaMemcpyHostToDevice);

    float* d_res;
    cudaMalloc(&d_res, 2*sizeof(float));
    cudaMemset(d_res, 0, 2*sizeof(float));
    
    parent_kernel <<< 10, 10 >>> (d_arr, d_res);
    
    float* res = (float *)malloc(2*sizeof(float));
    cudaMemcpy(res, d_res, 2*sizeof(float), cudaMemcpyDeviceToHost);

    printf("res = %f, %f\n", res[0], res[1]);

    return 0;
}