clc;
clearvars;
%only 2T
%2fwd
%ERROR....
% market expiries; coincide with expiries of the LV matrix
T = [0.00822 0.01918];

% forwards at market expiries
Fwd = [4.50708 4.50708];

% market strikes
K = [
    4.41060	4.41060;
    4.45479	4.45479;
    4.50809	4.50809;
    4.56930	4.56930;
    4.63267	4.63267];

% LV matrix 
MktVol = [
    0.1903	0.1203;
    0.4975	0.1275;
    0.2050	0.1350;
    0.2175	0.1475;
    0.2323	0.1623];

% normalized market strikes
[rows, cols] = size(K);
K_norm = K ./ repmat(Fwd, rows, 1);

% Dupire solver settings
Lt = 10;
Lh = 200;
K_min = 0.1;
K_max = 3;
Scheme = 'cn';

% calibration settings
Threshold = 0.0010;
MaxIter = 100;

[V, ModelVol, MaxErr] = calibrator(T,K_norm,MktVol,Threshold,MaxIter,Lt,Lh,K_min,K_max,Scheme);
%there is an arbitrage in time,order to avoid arb we need costraints
%no way to calibrate the model
price_t1 = blsprice(Fwd(1),K(1,1),0,T(1),MktVol(1,1))
price_t2 = blsprice(Fwd(2),K(1,2),0,T(2),MktVol(1,2))

