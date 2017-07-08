#include <iostream>
#include <ctime>
#include <cstdlib>
#include <cstdio>
#include <assert.h>
#include <algorithm>
#include <math.h>
#include <vector>
#include <iomanip>
#include "mex.h"
#include "mexOliUtil.h"
#include "BCAGM3_QuadSolver.h"

using namespace std;

void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray*prhs[] ) {
    
    enum{ indH1i, valH1i, indH2i, valH2i, indH3i, valH3i, N1i, N2i, X0i, subroutinei, adapti};
    enum{ Xouto, objso, nItero};
    oliCheckArgNumber(nrhs, 11, nlhs, 3);
    
    int Nt1, Nt2, Nt3;
    int* indH1 = (int*)oliCheckArg(prhs, indH1i, 1, &Nt1, oliInt);
    double* valH1 = oliCheckArg(prhs, valH1i, Nt1, 1, oliDouble);
    
    int* indH2 = (int*)oliCheckArg(prhs, indH2i, 2, &Nt2, oliInt);
    double* valH2 = oliCheckArg(prhs, valH2i, Nt2, 1, oliDouble);
    
    int* indH3 = (int*)oliCheckArg(prhs, indH3i, 3, &Nt3, oliInt);
    double* valH3 = oliCheckArg(prhs, valH3i, Nt3, 1, oliDouble);
    
    int* pN1 = (int*)oliCheckArg(prhs, N1i, 1, 1, oliInt);
    int* pN2 = (int*)oliCheckArg(prhs, N2i, 1, 1, oliInt);
    int N1 = *pN1, N2 = *pN2;
    
    double* X0 = oliCheckArg(prhs, X0i, N1*N2*2, 1, oliDouble);
    int* subroutine = (int*)oliCheckArg(prhs, subroutinei, 1, 1, oliInt);
    int* adapt = (int*)oliCheckArg(prhs, adapti, 1, 1, oliInt);
    
    plhs[Xouto] = mxCreateDoubleMatrix(N2, N1, mxREAL);
    double* Xout = mxGetPr(plhs[Xouto]);
    plhs[objso] = mxCreateDoubleMatrix(1, 1000, mxREAL);
    double* objs = mxGetPr(plhs[objso]);
    plhs[nItero] = mxCreateDoubleScalar(0);
    double* nIter = mxGetPr(plhs[nItero]);
    
    if (*adapt == 0) {
        bcagm3_quad(indH3, valH3, Nt3,
                X0, N1, N2, *subroutine, Xout, objs, nIter);
    } else {
        adapt_bcagm3_quad(indH3, valH3, Nt3,
                X0, N1, N2, *subroutine, *adapt, Xout, objs, nIter);
    }
}

