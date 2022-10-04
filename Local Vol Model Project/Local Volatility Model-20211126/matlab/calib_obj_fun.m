function res = calib_obj_fun(T,K,MktVol,V,Lt,Lh,K_min,K_max,Scheme)
% Computes model implied volatility at strike K and expiry T and returns
% the difference with the corresponding market implied volatility

% model volatility using LV matrix V
%means solve dupire and invert using black formula from prices to impl
%volatilities
ModelVol = model_volatility(T,K,V,Lt,Lh,K_min,K_max,Scheme);

% compute the difference between model and mkt volatilities
res = ModelVol - MktVol;
