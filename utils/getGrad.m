function grad = getGrad(indH, valH, X)

grad = mexGetGrad(indH, valH, X(:));