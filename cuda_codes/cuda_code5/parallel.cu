#include <iostream>
#include <cuda.h>
using namespace std;

__global__ void compute_dis(int *x, int *y, double* dis, int n){
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  int j = blockIdx.y * blockDim.y + threadIdx.y;

  if(i < n && j < n){
    if(i < j){
      int dis_x = x[i] - x[j];
      int dis_y = y[i] - y[j];
      dis[i*n + j] = sqrt(dis_x * dis_x + dis_y * dis_y);
      printf("%lf\n", dis[i*n + j]);
    }else dis[i*n+j] = 0;
  }
}

template <typename T>
__global__ void compute_max(T* arr, int n, int chunck_size, T* result){
  // each thread finds the maximum of chunck_size number of elements
  int start = blockIdx.x * blockDim.x * chunck_size + threadIdx.x * chunck_size;

  if(start < n){
    T max_ele = arr[start];
    for(int i = start + 1; i <= start + chunck_size - 1 && i < n; i++){
      if(arr[i] > max_ele) max_ele = arr[i];
    }
    printf("thread: %d\n", blockIdx.x * blockDim.x + threadIdx.x);
    result[blockIdx.x * blockDim.x + threadIdx.x] = max_ele;
  }
}

// finding maximum of a n-sized array
template <typename T>
T find_max(T* d_arr, int n){
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
    cout << "num_blocks = " << num_blocks << "\n";
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
  cin >> n;

  // taking input from user
  int x[n];
  int y[n];
  for(int i = 0; i < n; i++){
    cin >> x[i] >> y[i];
  }

  int *dx;
  cudaMalloc(&dx, n * sizeof(int));
  cudaMemcpyAsync(dx, x, n * sizeof(int), cudaMemcpyHostToDevice);

  int *dy;
  cudaMalloc(&dy, n * sizeof(int));
  cudaMemcpyAsync(dy, y, n * sizeof(int), cudaMemcpyHostToDevice);

  double *dis;
  cudaMalloc(&dis, n * n * sizeof(double));

  dim3 block(32, 32);
  dim3 grid((n + 31)/ 32, (n + 31)/ 32);

  compute_dis <<< grid, block >>> (dx, dy, dis, n);
  cudaDeviceSynchronize();

  // finding maximum of a n*n sized array
  // find_max has cudaDeviceSynchronize() at the end
  double max_ele = find_max(dis, n*n);

  cout << "Maximum euclidian distance: " << max_ele << "\n";

  cudaFree(dx);
  cudaFree(dy);

  return 0;
}