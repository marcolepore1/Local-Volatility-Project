clc;
clearvars;

% market data
spot = 100;
T = 2;
disc_fact = 0.99;
fwd = 101;

% model data
r = -log(disc_fact)/T;
q = -log(fwd*disc_fact/spot)/T;

% price as a function of volatility
sigma = 0:0.01:5;
K = 90;

% limit prices
min_price = disc_fact*(fwd-K);
max_price = disc_fact*fwd;

% [Call,Put] = blsprice(Price, Strike, Rate, Time, Volatility, Yield)
price = blsprice(spot,K,r,T,sigma,q);

% equivalently blsprice(Forward, Strike, 0, Time, Volatility, 0)*DiscFact
price2 = blsprice(fwd,K,0,T,sigma,0)*disc_fact;

figure;
plot([sigma sigma(end)],[price max_price], [sigma sigma(end)],[price2 max_price]);
title('Black-Scholes price as function of volatility for fixed K,T');

ax = gca;
ax.YTick = [min_price max_price];
ax.YTickLabel = {'min = D(T)*(F(T)-K)' 'max = D(T)*F(T)'};
ax.YGrid = 'on';
