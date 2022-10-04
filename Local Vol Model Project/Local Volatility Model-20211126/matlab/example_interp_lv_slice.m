clc;

K = [0.5 0.75 1 1.25 1.5];
V = [0.20 0.18 0.15 0.17 0.19];

k=0.1:0.01:2;
eta = interp1(K,V,k,'spline'); 
eta_spline = interp_flat_extrap(K,V,k,'spline'); 
eta_lin = interp_flat_extrap(K,V,k,'linear'); 

figure;
plot(K,V,'o',k,eta_lin,':.');
title('Local Volatility function (linear + flat extrapolation)');
figure;
plot(K,V,'o',k,eta_spline,':.');
title('Local Volatility function (spline + flat extrapolation)');
figure;
plot(K,V,'o',k,eta,':.');
title('Local Volatility function (spline interpolation)');