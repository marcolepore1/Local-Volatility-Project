clc;
clearvars;

% spot
Spot = 3560;

% market expiries; coincide with expiries of the LV matrix
T = [ 0.063 0.159 0.312 0.562 0.830 1.079 1.578 2.077 2.575 3.074 4.071 5.068];

% discount factor at market expiries
r = [-0.0039 -0.0033 -0.0029 -0.0018 -0.0024 -0.0031 -0.0024 -0.0011 0.0022 0.005 0.005 0.0077];

% dividend yield at market expiries
q = [-0.03 -0.01 -0.01 0 0 0.01 0.01 0.015 0.15 0.02 0.02 0.02];

expiry = 0:0.5:7;

for i=1:length(expiry)
    model_fwd(i) = forward(Spot,T,r,q,expiry(i));
    model_disc_fact(i) = discount(T,r,expiry(i));
end

% plot
figure;
plot(expiry,model_fwd);
title('Model forwards as a function of time');

figure;
plot(expiry,model_disc_fact);
title('Model discount factors as a function of time');

