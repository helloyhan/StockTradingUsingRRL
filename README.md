# StockTradingUsingRRL
To implement the key algorithm of this paper(http://cs229.stanford.edu/proj2006/Molina-StockTradingWithRecurrentReinforcementLearning.pdf) in KDB+/q, 

## Trade Function
Instead of using the $tanh$ function described in this paper, also implement other types of functions, such as
- Logistic function
    - Definition: $$f(x)=\frac{L}{1+e^{-kx}}=\frac{Le^{kx}}{1+e^{kx}}$$
    - Derivative: $$\frac{d}{dx}f(x)=\frac{kLe^{kx}(1+e^{kx})-kLe^{kx}e^{kx}}{(1+e^{kx})^2}=\frac{kLe^{kx}}{(1+e^{kx})^2}=\frac{k}{L}f(x)(L-f(x))$$


The functions are implemented in **tradeFunction.q**

