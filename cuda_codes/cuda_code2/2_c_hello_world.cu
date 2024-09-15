#include <stdio.h>
#include <cuda.h>

// kernel
__global__ void cuda_kernel(){
    printf("Hello world\n");
}

int main(){
    cuda_kernel <<< 1, 5>>>(); // kernel launch (or) kernel invocation
    cudaDeviceSynchronize();   // this is must to make host wait until device completed its tasks
    return 0;
}