clc;
clearvars;

% spot
Spot = 13068.97;


% market expiries; coincide with expiries of the LV matrix
T = [ 0.063 0.216 0.499 0.734 0.984 1.482 1.981 3.225];


% forwards at market expiries
Fwd = [13067.79 13068.68 13073.05 13080.97 13083.16 13087.18  13098.35    13180.20];

% discount factor at market expiry
DF = [1.0003070 1.0007990 1.0013780 1.0017260 1.0024670 1.0035520 1.0038150 1.0003680];

% market strikes
K = [
   12100	11100	9900	8900    8500     7700   7100	6300;
    12700	12500	12100	11700   11500    11100  10900	10500;
    12900	12900	12700   12700   12500    12500  12300   12100
    13100	13100	13100	13100   13100    13100  13100	13100;
    13300	13300	13300	13500   13500    13700  13900	14300;
    13500	13500	13900	14100   14100    14700  15100	16100;
    13700	14300	14900	15300   15900    16900  18100	21300];


% LV matrix
V = [
     0.1750	0.2194	0.2472	0.2687	0.2657	0.2676	0.2630	0.2593;
    0.1501	0.1588	0.1765	0.1886	0.1925	0.1964	0.1956	0.1973;
    0.1421	0.1425	0.1585	0.1628	0.1707	0.1723	0.1776	0.1843;
    0.1341	0.1345	0.1469	0.1529	0.1582  0.1626	0.1684	0.1778;
    0.1267	0.1271	0.1412	0.1435	0.1503	0.1538	0.1604	0.1719;
    0.1208	0.1211	0.1268	0.1319	0.1372	0.1424	0.1515	0.1678;
    0.1162	0.1105	0.1103	0.1161	0.1201	0.1286	0.1415	0.1675];


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
    if k(i)>0.9001 && k(i)<1.1
        perc_strikes_spot_start = [perc_strikes_spot_start k(i)];
        model_impl_vol_spot_start = [model_impl_vol_spot_start blsimpv(1,k(i),0,Expiry,C(i))];
    end
end

% forward-start option data
expiry(1) = 2;
expiry(2) = expiry(1) + 0.5;

% additional market data
discount_factor = interp1(T,DF,expiry(2));
fwd(1) = interp1(T,Fwd,expiry(1));
fwd(2) = interp1(T,Fwd,expiry(2));

N=1000000; %MC simulations
M=50; %timesteps

% MC simulation
S = lv_simulation_log(T,Fwd,V,K,N,M,expiry);

% option prices
perc_strikes = 0.9:0.05:1.1;
model_impl_vol=[];
for x = perc_strikes
    P = discount_factor*mean(max(S(2,:) - x*S(1,:),0));
    model_impl_vol = [model_impl_vol, blsimpv(fwd(2),x*fwd(1),0,expiry(2)-expiry(1),P/discount_factor)];
end

plot(perc_strikes_spot_start,model_impl_vol_spot_start,perc_strikes,model_impl_vol);
title('Model implied vol with option maturity 6m');
legend('Spot vol','Fwd vol (starts in 2y)')



