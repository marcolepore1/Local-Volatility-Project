clc;
clearvars;

% spot
spot = 3573.22;

% market expiries; coincide with expiries of the LV matrix
T = [ 0.063 0.159 0.312 0.562 0.830 1.079 1.578 2.077 2.575 3.074 4.071 5.068];

% forwards at market expiries
Fwd = [3569.94 3563.83 3556.12 3473.93 3463.98 3446.99 3352.65 3329.88 3241.51 3225.23 3131.97 3053.65];

% discount factor at market expiry
DF = [1.0002428 1.0005586 1.0010088 1.0014682 1.0022950 1.0030480 1.0042523 1.0048028 1.0036823 1.0017654 0.9968106 0.9891393];

% market strikes
K = [
    3300	3050	2850	2500	2300	2150	1850	1700	1500	1350	1050	850;
    3450	3450	3350	3150	3100	3000	2800	2750	2600	2500	2350	2200;
    3500	3500	3500	3350	3350	3300	3150	3100	3000	2950	2850	2700;
    3550	3550	3550	3450	3450	3450	3350	3350	3250	3250	3150	3050;
    3600	3600	3600	3550	3600	3600	3550	3550	3500	3500	3450	3400;
    3650	3650	3700	3700	3750	3800	3800	3850	3850	3950	4000	4050;
    3700	3800	3950	4000	4150	4250	4450	4650	4850	5150	5550	5950];

% LV matrix
V = [
    0.3129	0.4443	0.3646	0.4332	0.4405	0.3815	0.4093	0.3906	0.4563	0.4486	0.6495	0.7279;
    0.1864	0.1669	0.2070	0.2410	0.2368	0.2414	0.2474	0.2270	0.2358	0.2124	0.2250	0.2269;
    0.1520	0.1459	0.1641	0.1935	0.1908	0.2029	0.2088	0.2015	0.2104	0.2000	0.2095	0.2154;
    0.1241	0.1211	0.1474	0.1706	0.1706	0.1814	0.1870	0.1806	0.1933	0.1882	0.1955	0.2006;
    0.0911	0.0988	0.1387	0.1433	0.1432	0.1609	0.1633	0.1659	0.1767	0.1791	0.1847	0.1902;
    0.0798	0.0829	0.1083	0.1238	0.1295	0.1443	0.1499	0.1535	0.1668	0.1808	0.1832	0.1974;
    0.1014	0.0939	0.1189	0.1030	0.1141	0.1246	0.1426	0.1448	0.1755	0.2058	0.1965	0.2157];


% spot start option data
Expiry = 0.562;

% normalized LV strikes
[rows, cols] = size(K);
K_norm = K ./ repmat(Fwd, rows, 1);

% Dupire solver details
Lt = 10;
Lh = 200;
K_min = 0.1;
K_max = 3;
Scheme = 'cn';

% compute price of spot-start call options 
[ k, C ] = solve_dupire( T, K_norm, V, Expiry, Lt, Lh, K_min, K_max, Scheme);    

% compute model implied volatilities
perc_strikes_spot_start=[];
model_impl_vol_spot_start=[];
for i=1:length(k)
    if k(i)>0.8001 && k(i)<1.2
        perc_strikes_spot_start = [perc_strikes_spot_start k(i)];
        model_impl_vol_spot_start = [model_impl_vol_spot_start blsimpv(1,k(i),0,Expiry,C(i))];
    end
end

% forward-start option data
expiry(1) = 2.013;
expiry(2) = expiry(1) + 0.562;

% additional market data
discount_factor = interp1(T,DF,expiry(2));
fwd(1) = interp1(T,Fwd,expiry(1));
fwd(2) = interp1(T,Fwd,expiry(2));

N=1000000; %MC simulations
M=50; %timesteps

% MC simulation
S = lv_simulation_log(T,Fwd,V,K,N,M,expiry);

% option prices
perc_strikes = 0.8:0.05:1.2;
model_impl_vol=[];
for x = perc_strikes
    P = discount_factor*mean(max(S(2,:) - x*S(1,:),0));
    model_impl_vol = [model_impl_vol, blsimpv(fwd(2),x*fwd(1),0,expiry(2)-expiry(1),P/discount_factor)];
end

plot(perc_strikes_spot_start,model_impl_vol_spot_start,perc_strikes,model_impl_vol);
title('Model implied vol with option maturity 6m');
legend('Spot vol','Fwd vol (starts in 2y)')



