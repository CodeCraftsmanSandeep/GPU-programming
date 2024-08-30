#include <stdio.h>
#include <cuda.h>

// kernel
__global__ void cuda_kernel(){
    printf("Hello world\n");
}

int main(){
    cuda_kernel <<< 1, 2>>>(); // kernel launch (or) kernel invocation
    return 0;
}


// this code will not give any output
// think why?
// see next code to get answer