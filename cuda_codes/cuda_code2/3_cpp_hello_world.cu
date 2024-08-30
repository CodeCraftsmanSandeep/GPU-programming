#include <bits/stdc++.h> // these many libraries are imported to just check whether everything is cool!! or not
#include <cuda.h>
using namespace std;

__global__ void cuda_kernel(){
    // cout << threadIdx.x << ") " << "Hello world\n";
    printf("thread %d, block %d) Hello world\n", threadIdx.x, blockIdx.x);  // Use printf instead of cout
}

int main(){
    cuda_kernel <<< 2, 4>>> ();
    cout << "Cpp code\n";
    cout << "\n";
    cudaDeviceSynchronize();
}

/*
The output may vary because the scheduling of thread blocks across Streaming Multiprocessors (SMs) is arbitrary.

For example, one possible output might be:
    Cpp code:

    thread 0, block 1) Hello world
    thread 1, block 1) Hello world
    thread 2, block 1) Hello world
    thread 3, block 1) Hello world
    thread 0, block 0) Hello world
    thread 1, block 0) Hello world
    thread 2, block 0) Hello world
    thread 3, block 0) Hello world

While another possible output could be:
    Cpp code:

    thread 0, block 0) Hello world
    thread 1, block 0) Hello world
    thread 2, block 0) Hello world
    thread 3, block 0) Hello world
    thread 0, block 1) Hello world
    thread 1, block 1) Hello world
    thread 2, block 1) Hello world
    thread 3, block 1) Hello world
*/