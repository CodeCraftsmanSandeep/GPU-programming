#include <iostream>
#include <cstdio.h>
using namespace std;

template <typename T>
T find_max(T *arr, int n){
    if(n == 0) return -1;
    T max_ele = arr[0];
    for(int i = 1; i < n; i++){
        if(max_ele < arr[i]) max_ele = arr[i];
    }
    return max_ele;
}

int main(){
    int n;
    cin >> n;

    double *arr = (double *)malloc(n*sizeof(double));
    for(int i = 0; i < n; i++) cin >> arr[i];

    cout << find_max(arr, n) << "\n";
}