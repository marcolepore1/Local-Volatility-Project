clc;
clearvars;

% market data
spot = 147.5;
T = 36/365;
r = 0.0124; 
DiscFact = exp(-r*T);
Fwd = 146.32;

% market strikes
K = [130 135 140 145 150 155 160 165 170];

% market prices of call options
% notice that first price is wrong since less than DiscFact*(Fwd-K)
P = [16.10 14.07 8.925 4.75 2.06 0.695 0.21 0.065 0.05]; 

% implied volatilities
impl_vol(:) = blsimpv(Fwd,K(:),0,T,P(:)/DiscFact);

% correct prices and implied volatilities
P_correct = [19.35 14.07 8.925 4.75 2.06 0.695 0.21 0.065 0.05]; 
impl_vol_correct(:) = blsimpv(Fwd,K(:),0,T,P_correct(:)/DiscFact);

figure;
plot(K,impl_vol,K,impl_vol_correct,':.');
title(['Implied volatility smile for expiry ', num2str(T)]);

