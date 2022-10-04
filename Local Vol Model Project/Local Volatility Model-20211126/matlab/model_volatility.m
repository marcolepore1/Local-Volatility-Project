function [vol] = model_volatility(T,K_norm,V,Lt,Lh,K_min,K_max,Scheme)
%HIGHLY INEFFICIENT
%IMPROVE IT IN THE LAB
% Compute model implied volatility of a local volatility model
% T.. LV expiries, K_norm.. LV strikes, V.. LV matrix
% Lt,Lh,K_min,K_max,Scheme.. settings for the Dupire solver
%
% vol(i,j).. model implied volatility at time T(i) and strike K_norm(i,j) 

[rows, cols] = size(K_norm);
vol = zeros(rows,cols);

for idx = 1:length(T)
    expiry = T(idx);
    %%HERE WE SOLVE DUPIRE
    [ k, C ] = solve_dupire( T, K_norm, V, expiry, Lt*idx, Lh, K_min, K_max, Scheme);
    price = interp1(k,C,K_norm(:,idx));
    %%INVERT USING BLACK FORMULA
    vol(:,idx) = blsimpv(1,K_norm(:,idx),0,expiry,price);
    %%EACH TIME U RESOLVE ALSO TIMES WE'VE SOLVED
    %%HERE HE WANTS TO SOLVE DUPIRE EQ ONLY ONCE FOR EVERY TIME 
end
end

