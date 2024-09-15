#include <iostream>
#include <cuda.h>
#include <iomanip>

template <typename T>
__global__ void compute_max(T* arr, int n, int chunck_size, T* result){
  // each thread finds the maximum of chunck_size number of elements
  int start = blockIdx.x * blockDim.x * chunck_size + threadIdx.x * chunck_size;

  if(start < n){
    T max_ele = arr[start];
    for(int i = start + 1; i <= start + chunck_size - 1 && i < n; i++){
      if(arr[i] > max_ele) max_ele = arr[i];
    }
    // printf("thread: %d\n", blockIdx.x * blockDim.x + threadIdx.x);
    result[blockIdx.x * blockDim.x + threadIdx.x] = max_ele;
  }
}

// finding maximum of a n-sized array
template <typename T>
T find_max(T* arr, int n){
  T* d_arr;
  cudaMalloc(&d_arr, n*sizeof(T));
  cudaMemcpyAsync(d_arr, arr, n*sizeof(T), cudaMemcpyHostToDevice);

  T* swap_arr;
  cudaMalloc(&swap_arr, n*sizeof(T));

  // chunck_size: is elements alloted to each cuda thread
  int chunck_size = 16;

  // elements alloted to each thread block is: threads_per_block * chunck_size (here = 512 * 16 = 8192)
  int threads_per_block = 512;
  int total_chunck = chunck_size * threads_per_block;

  bool use_swap_arr = false;
  while(n > 1){
    int num_blocks = (n + total_chunck - 1)/ total_chunck;
    if(use_swap_arr == false) compute_max <<< num_blocks, threads_per_block >>> (d_arr, n, chunck_size, swap_arr);
    else compute_max <<< num_blocks, threads_per_block >>> (swap_arr, n, chunck_size, d_arr);
    use_swap_arr = !use_swap_arr;
    n = (n + chunck_size - 1)/chunck_size;
  }
  cudaDeviceSynchronize();

  T* max_ptr = (T*)malloc(sizeof(T));
  if(use_swap_arr == false) cudaMemcpy(max_ptr, d_arr, sizeof(T), cudaMemcpyDeviceToHost);
  else cudaMemcpy(max_ptr, swap_arr, sizeof(T), cudaMemcpyDeviceToHost);

  return *max_ptr;
}

int main(){
    int n;
    std::cin >> n;

    double *arr = (double *)malloc(n*sizeof(double));
    for(int i = 0; i < n; i++) std::cin >> std::setprecision(10) >> arr[i];

    std::cout << std::setprecision(10) << find_max(arr, n) << "\n";
}