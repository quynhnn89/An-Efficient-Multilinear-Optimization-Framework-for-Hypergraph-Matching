#include "mex.h"
#include "mexOliUtil.h"

void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
    enum{ indH3i, valH3i, dimi, Xi};
    enum{ grado};
    oliCheckArgNumber(nrhs, 4, nlhs, 1);
    
    int Nt3;
    int* indH3 = (int*)oliCheckArg(prhs, indH3i, 3, &Nt3, oliInt);
    double* valH3 = oliCheckArg(prhs, valH3i, Nt3, 1, oliDouble);
    int* dim = (int*)oliCheckArg(prhs, dimi, 1, 1, oliInt);
    double* X = oliCheckArg(prhs, Xi, *dim, 1, oliDouble);
    
    plhs[grado] = mxCreateDoubleMatrix(1, *dim, mxREAL);
    double* grad = mxGetPr(plhs[grado]);
    
    for(int i = 0; i < *dim; ++i) grad[i] = 0;
    for(int i = 0; i < Nt3; ++i) {
        grad[indH3[i]] += valH3[i] * X[indH3[i]+1] * X[indH3[i]+2];
    }   
}