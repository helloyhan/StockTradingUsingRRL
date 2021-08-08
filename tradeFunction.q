.tradeFunc.logistic:{[x;w] 1%1+exp neg sum w*x};
.tradeFuncDeriv.logistic:{[x;w] f:.tradeFunc.logistic[x;w];x*f*1-f};
