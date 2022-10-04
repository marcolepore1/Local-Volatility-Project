clc;
clearvars;

% expiries of the LV matrix
T = [1 2];

% discount factor at LV expiry
DF = [1 1]; % r = [0 0]

% forwards at LV expiries
Fwd = [1 1]; % q = [0 0]

% LV strikes
K = [0.5 0.4; 
     1   1; 
     1.5 1.9];

% LV matrix
V = [0.2 0.2; 
     0.2 0.2; 
     0.2 0.2];

% option data
expiry(1) = 2;
expiry(2) = 2.5;
strike = [0.9 1.1];

% MC settings
N = 100000; %MC simulations we have the idea of the error 
M = 100; %timesteps

% MC simulation
S = lv_simulation_log(T,Fwd,V,K,N,M,expiry);

% option price
discount_factor = interp1(T,DF,expiry(2));
%fwd_at_expiry = forward(Spot,T,r,q,expiry(2))
; % = discount(T,r,expiry);
call_price1 = discount_factor*mean(max(S(1,:) - strike,0));
call_price2 = discount_factor*mean(max(S(2,:) - strike,0));


% model implied volatility
fwd = 1; % = forward(T,r,q,expiry);
model_impl_vol = blsimpv(fwd,strike,0,expiry,call_price/discount_factor)
