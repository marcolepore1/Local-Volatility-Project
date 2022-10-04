clc;
clearvars;

% market expiries; coincide with expiries of the LV matrix
T = [1 2];

% nodes of the LV matrix of a normalized asset X
K = [0.5 0.4; 
     1   1; 
     1.5 1.9];

% LV matrix of a normalized asset X
V = [0.2 0.2; 
     0.2 0.2; 
     0.2 0.2];

% find model price of 1y call options
expiry = 1;

% solve Dupire equation to find prices {C(i)} of call options on the 
% normalized asset X with the given expiry on a grid of strikes {k(i)}
Lt = 50; Lh = 1000; K_min = 0.05; K_max = 3; scheme = 'cn';
[ k, C ] = solve_dupire(T,K,V,expiry,Lt,Lh,K_min,K_max,scheme);

% compute model prices of options with the given expiry and having strikes
% equal to the nodes of the LV matrix
idx = find(T>expiry-0.001,1);
strikes = K(:,idx);
prices = interp1(k,C,strikes);
model_impl_vols = blsimpv(1,K(:,idx),0,expiry,prices)
