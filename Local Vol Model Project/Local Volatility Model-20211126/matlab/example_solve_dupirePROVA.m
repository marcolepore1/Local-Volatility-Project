clc;
clearvars;
%%UNICO PROBLEM: COSA METTERE IN r E IN q

% spot
Spot = 13068;

% market expiries; coincide with expiries of the LV matrix
T = [ 0.063 0.216 0.499 0.734 0.984 1.482 1.981 3.225];

% discount factor at market expiries
r = [-0.0039 -0.0033 -0.0029 -0.0018 -0.0024 -0.0031 -0.0024 -0.0011 0.0022 0.005 0.005 0.0077];

% dividend yield at market expiries
q = [-0.03 -0.01 -0.01 0 0 0.01 0.01 0.015 0.15 0.02 0.02 0.02];

% market strikes; coincide with nodes of the LV matrix
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

% option data
expiry = 0.5;
strike =[ 0.9 1.1]*Spot;

% solve dupire: find prices C of options with given expiry and strikes k
% normalized market strikes
[rows, columns] = size(K);
K_norm = zeros(rows, columns);
for j=1:columns
   fwd = forward(Spot,T,r,q,T(j));
   for i=1:rows
      K_norm(i,j) = K(i,j) / fwd;
   end
end
Lt = 100; Lh = 1000; K_min = 0.01; K_max = 3.5; scheme = 'cn';
[ k, C ] = solve_dupire(T,K_norm,V,expiry,Lt,Lh,K_min,K_max,scheme);

% normalized option price
fwd_at_expiry = forward(Spot,T,r,q,expiry);
norm_strike = strike/fwd_at_expiry;
norm_price = interp1(k,C,norm_strike);
model_impl_vol_1 = blsimpv(1,norm_strike,0,expiry,norm_price);

% option price
disc_fact_at_expiry = discount(T,r,expiry);
price = fwd_at_expiry * disc_fact_at_expiry * norm_price;
model_impl_vol_2 = blsimpv(fwd_at_expiry,strike,0,expiry,price/disc_fact_at_expiry);

