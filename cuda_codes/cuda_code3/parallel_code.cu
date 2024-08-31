#include <iostream>
#include <cuda.h>
#define N 100
using namespace std;

__global__ void my_kernel(){
    printf("%d\n", threadIdx.x);
}

int main(){
    my_kernel <<< 1, N>>> ();
    cudaDeviceSynchronize();
    return 0;
}

// 0 - 99 need not be printed in serial
// the order is arbitary