- CUDA
  - Compute Unified Device Architecture

# Table of contents
| S.no | codes | notes | keywords |
|:-----|:------|:------|:---|
| 1 | [cuda_code1](cuda_code1) | compile hello world c or cpp cuda code using "nvcc -o my_program.out my_program.cu" <br/> note that the codes here are still runnning on cpu and not on gpu | |
| 2 | [cuda_code2](cuda_code2) | launching cuda kernel using c (or) cpp code. Generally gpu's are not used for single IO like PC's (or) general computers. But if there are multiple IO's then I think we can throw output simultaneously at different IO screens. (But curently this is not feasible by cuda thread, a cuda thread cannot send a email using API's as it is a core in nvidia is simple than cpu. We can use multi-threading in CPU to do the same) | cudaDeviceSynchronize(), cuda kernal launch |
| 3 | [cuda_code3](cuda_code3) | The serial code prints all the numbers 1 to N in sequence, but where as the order in which numbers are outputed by parallel code is arbitary(at least to non-nvidia people). | |
| 4 | [cuda_code4](cuda_code4) | Addition of vectors | cudaMalloc(), cudaMemcpy(), cudaMemcpyAsync() cudaMemcpyDeviceHostToDevice, cudaMemcpyDeviceToHost |

