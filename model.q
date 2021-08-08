TRANSACTION_COST_RATIO:0.0002;
LEARNING_RATE:3000.0;

.model.train.iterate:{[train;iter]
    / one iteration of train
    train:update T:count r by symbol from train;
    train:delete f from update F:.rolling.single[first f;N_PARAM;r] by symbol from update f:.tradeFunc.logistic[;first w] by symbol from train;
    train:update R:(prev[F]*r)-TRANSACTION_COST_RATIO*abs F-prev[F] by symbol from train;
    train:update A:avg R, B:avg xexp[R;2] by symbol from train;
    train:update S:%[A;sqrt B-xexp[A;2]] by symbol from train;

    train:update dSdA:S*(1+xexp[S;2])%A, dSdB:neg xexp[S;3]%2*xexp[A;2], dAdR:1.0%T, dBdR:2.0*R%T by symbol from train;
    train:update dRdF:neg TRANSACTION_COST_RATIO*signum F-prev F, dRdFp:r+TRANSACTION_COST_RATIO*signum F-prev F by symbol from train;
    train:delete drv from update dFdw:.rolling.single[first drv;N_PARAM;r] by symbol from update drv:.tradeFuncDeriv.logistic[;first w] by symbol  from train;
    train:update dFpdw:prev[dFdw] by symbol from train;
    train:update dSdw:(*[dSdA;dAdR] + *[dSdB;dBdR]) * (*[dRdF;dFdw] + *[dRdFp;dFpdw]) by symbol from train where i>N_PARAM+(min;i) fby symbol;

    grad:select grad:{(+) over x}[dSdw] by symbol from train where i>N_PARAM+(min;i) fby symbol;
    train:train lj grad;
    train:update w:{x+y}[w;LEARNING_RATE*grad] by symbol from train;

    / record the objectives by iteration
    obj:0!select iteration:iter, Sharpe:first S by symbol from train;
    / record the parameter by iteration
    param:update iteration:iter from flip exec (`symbol, `$"w" ,/: string 1+til N_PARAM)!flip (symbol,'w) from train where i=(min;i) fby symbol;

    :(train;obj;param);
    };


.model.train.initWeights:{[train;weight]
    T:count train;
    train:update w:T#weight from train;
    :train; 
    };


.model.train.run:{[train;numIter]
    i:0;
    objs:([] symbol:();iteration:();Sharpe:());
    params:![([] symbol:();iteration:());();0b;(`$"w" ,/: string 1+til N_PARAM)!N_PARAM#()];

    while[i<numIter;r:.model.train.iterate[train;i];train:r[0];objs,:r[1];params,:r[2];i+:1];

    :(train;objs;params);
    };



/ 
/ Example of training
N:2000;
prices:([] symbol:N#`s;close:100.0*1+prds 1+0.01*-4.2+N?10);
prices:update r:-1+close%prev close from prices;

train:prices;
N_PARAM:6;
train:.model.train.initWeights[train;enlist 1.0 2.0 -1.0 -1.0 2.0 0.0];
r:.model.train.run[train;2000];


