#include <iostream>
using namespace std;

__global__ void find(int* x, int* y, int n){
    int i = blockIdx.x;
    int j = threadIdx.x;

    if(i < j){
        computation[i*blockDimx.x + j] = sqrt(x[i] - x[j])**2 + 
    }
}

int threads = n * (n-1)/2;
int blocksize = 32;
int grids = (threads + blocksize - 1) / blocksize;
find <<< n, n >>> ()
 <<< (n+31/32, n + 31/32), (32, 32) >>>

 int i = blockIdx.x*blockDimx.x + threadIdx.x;
 int j = blockIdx.y*blockDimx.y + threadIdx.y;
 