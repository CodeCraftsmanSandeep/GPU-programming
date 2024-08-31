#include <iostream>
#include <cuda.h>
using namespace std;

#define N 1024

__global__ void add_vectors(int* vec1, int* vec2, int* vec){
    vec[threadIdx.x] = vec1[threadIdx.x] + vec2[threadIdx.x];
}

int main(){
    int vec1[N];
    for(int i = 0; i < N; i++) vec1[i] = i; // even this can be paralleized

    int vec2[N];
    for(int i = 0; i < N; i++) vec2[i] = i;

    int vec[N];

    int* vec1_gpu; 
    cudaError_t err = cudaMalloc(&vec1_gpu, N*sizeof(int));
    if(err != cudaSuccess){
        cout << "Cuda memory allocation failed\n";
        return 1;
    }

    // destination, course, size, direction
    cudaMemcpyAsync(vec1_gpu, vec1, N*sizeof(int), cudaMemcpyHostToDevice);
    // vec1_gpu is pointer is present in stack of cpu, but points to memeory allocated on gpu 

    int* vec2_gpu;
    err = cudaMalloc(&vec2_gpu, N*sizeof(int));
    if(err != cudaSuccess){
        cout << "Cuda memory allocation failed\n";
        return 1;
    }
    cudaMemcpyAsync(vec2_gpu, vec2, N*sizeof(int), cudaMemcpyHostToDevice);

    int* vec_gpu;
    err = cudaMalloc(&vec_gpu, N*sizeof(int));
    if(err != cudaSuccess){
        cout << "Cuda memory allocation failed\n";
        return 1;
    }
    
    add_vectors <<< 1, N>>> (vec1_gpu, vec2_gpu, vec_gpu);
    cudaMemcpy(vec, vec_gpu, N*sizeof(int), cudaMemcpyDeviceToHost); 
    // cudaMemcpy() is synchronous invocation of cudaMemcpy, so there is no need to use cudaDeviceSynchronize()

    cout << "Vector 1:\n";
    for(int i = 0; i < N; i++) cout << vec1[i] <<  " ";
    cout << "\n\n";

    cout << "Vector 2:\n";
    for(int i = 0; i < N; i++) cout << vec2[i] << " ";
    cout << "\n\n";

    cout << "Added vector:\n";
    for(int i = 0; i < N; i++) cout << vec[i] << " ";
    cout << "\n";

    return 0;
}

// there is also cudaMallocAsync() function
// but for using that we need streams
// we will understand this later