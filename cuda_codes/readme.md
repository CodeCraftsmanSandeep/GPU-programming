- CUDA
  - Compute Unified Device Architecture

# Table of contents
| S.no | codes | notes |
|:-----|:------|:------|
| 1 | [cuda_code1](cuda_code1) | compile hello world c or cpp cuda code using "nvcc -o my_program.out my_program.cu" <br/> note that the codes here are still runnning on cpu and not on gpu |
| 2 | [cuda_code2](cuda_code2) | launching cuda kernel using c (or) cpp code. Generally gpu's are not used for single IO like PC's (or) general computers. But if there are multiple IO's then I think we can throw output simultaneously at different IO screens. (But curently this is not feasible by cuda thread, a cuda thread cannot send a email using API's as it is a core in nvidia is simple than cpu. We can use multi-threading in CPU to do the same) |


