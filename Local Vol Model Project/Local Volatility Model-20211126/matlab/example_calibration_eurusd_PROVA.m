clc;
clearvars;

% spot
spot = 0.88670;

% market expiries; coincide with expiries of the LV matrix
T = [0.036 0.082 0.167 0.244 0.496 0.748 0.997];

% forwards at market expiries
Fwd = [0.887419 0.887825 0.888539 0.889228 0.891693 0.894473 0.897272];

% market deltas
Delta = [ 0.1 0.25 0.5 0.75 0.9]; %%ok

% LV matrix
MktVol = [0.0840 0.0713 0.0679 0.0699 0.0751 0.0749 0.0761;
    0.0768 0.0636 0.0659 0.0692 0.0722 0.0740 0.0754;
    0.0723 0.0659 0.0654 0.0685 0.071 0.0749 0.0766;
    0.0677 0.0682 0.0667 0.0708 0.0754 0.0784 0.0808;
    0.0771 0.07 0.0695 0.0735 0.0799 0.0832 0.0863 ];

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

