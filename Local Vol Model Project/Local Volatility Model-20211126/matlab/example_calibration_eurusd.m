clc;
clearvars;

% spot
spot = 1.16525;

% market expiries; coincide with expiries of the LV matrix
T = [0.019178082	0.038356164	0.087671233	0.17260274	0.257534247	0.495890411	0.747945205	1.005479452	2.005479452	3.008219178	4.005479452	5.002739726];

% forwards at market expiries
Fwd = [1.165639627	1.166041672	1.167000816	1.169889929	1.171802936	1.178346889	1.185553973	1.193050382	1.224864252	1.255109218	1.283845204	1.311200193];

% market deltas
Delta = [ 0.1 0.25 0.5 0.75 0.9];

% LV matrix
MktVol = [
    0.06188	0.06087	0.06312	0.06862	0.06925	0.07863	0.08138	0.08237	0.087	0.09188	0.09712	0.102;
    0.0605	0.0585	0.06	0.06475	0.06475	0.072	0.07375	0.07425	0.07825	0.0825	0.08775	0.09175;
    0.06	0.0575	0.0585	0.063	0.063	0.0685	0.07	0.071	0.0745	0.078	0.0835	0.087;
    0.0615	0.0595	0.061	0.06575	0.06625	0.071	0.07275	0.07475	0.07775	0.0805	0.08625	0.08925;
    0.06362	0.06263	0.06487	0.07037	0.07175	0.07688	0.07963	0.08313	0.086	0.08813	0.09438	0.097];

% market strikes
K = zeros(length(Delta),length(T));

% find K such that BS_Delta(K,Fwt,T,MktVol) = Delta
%computes the strikes corresponding to the computed delta
for i = 1:length(Delta)
    for j = 1:length(T)
        K(i,j) = fzero(@(Strike) blsdelta(Fwd(j),Strike,0,T(j),MktVol(i,j))-(1-Delta(i)), Fwd(j));
    end
end

% normalized market strikes
[rows, cols] = size(K);
K_norm = K ./ repmat(Fwd, rows, 1);

% Dupire solver settings
Lt = 20;
Lh = 300;
K_min = 0.5;
K_max = 2.5;
Scheme = 'cn';

% calibration settings
Threshold = 0.0010;
MaxIter = 100;

[V, ModelVol, MaxErr] = calibrator(T,K_norm,MktVol,Threshold,MaxIter,Lt,Lh,K_min,K_max,Scheme);

% plot local volatility function vs market implied volatility
figure;
plot(K(:,1),MktVol(:,1),'o',K(:,1),ModelVol(:,1),':.',K(:,1),V(:,1),':.b','linewidth',1.5);
title('Calibrated model and local volatility for asset EUR/USD');
legend('MktVol','ModelVol','LocalVol');

figure;
plot(MaxErr,'.','MarkerSize',15);
title('calibration error at each iteration of the fixed-point calibration');

