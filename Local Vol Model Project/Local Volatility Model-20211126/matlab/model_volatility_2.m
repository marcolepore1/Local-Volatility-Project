function [vol] = model_volatility_2(T,K_norm,V,Lt,Lh,K_min,K_max,Scheme)
% Compute model implied volatility of a local volatility model
% T.. LV expiries, K_norm.. LV strikes, V.. LV matrix
% Lt,Lh,K_min,K_max,Scheme.. settings for the Dupire solver
%
% vol(i,j).. model implied volatility at time T(i) and strike K_norm(i,j) 

[rows, cols] = size(K_norm);
vol = zeros(rows,cols);
Expiry=T(length(T));
[ k2, Call2,t_3 ] = solve_dupire_2( T, K_norm, V, Expiry, Lt, Lh, K_min, K_max, Scheme);

if strcmp(Scheme,'f')
    t_2=t_3;
elseif strcmp(Scheme,'b')
    t_2=t_3(2:length(t_3)) %orizzontale   
elseif strcmp(Scheme,'cn')
    t_2=t_3(2:length(t_3)); %orizzontale
end


price = interp1(t_2,Call2(1,:),T);
for i=2:length(k2)
    price=[price;interp1(t_2,Call2(i,:),T)];
end

price_2= interp1(k2,price(:,1),K_norm(:,1));
for i=2:length(T)
    price_2=[price_2,interp1(k2,price(:,i),K_norm(:,i))];
end



for i = 1:length(T)
    expiry = T(i);
    vol(:,i) = blsimpv(1,K_norm(:,i),0,expiry,price_2(:,i));
end

%vol = blsimpv(1,K_norm,0,expiry,price_2);
end




