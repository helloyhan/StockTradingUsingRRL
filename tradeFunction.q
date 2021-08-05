.tradeFunc.logistic:{[x;L;k] %[L*exp[k*x];1+exp[k*x]]};
.tradeFuncDeriv.logistic:{[x;L;k] *[k%L;.tradeFunc.logistic[x;L;k]*L-.tradeFunc.logistic[x;L;k]]};

/ {([] i:x;v:.tradeFunc.logistic[;1;1] each x;d:.tradeFuncDeriv.logistic[;1;1] each x)}[0.1 * -60 + til 130]
 