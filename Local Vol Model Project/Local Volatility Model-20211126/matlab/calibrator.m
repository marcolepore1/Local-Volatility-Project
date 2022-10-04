function [V, ModelVol, MaxErr] = calibrator(T,K_norm,MktVol,threshold,MaxIter,Lt,Lh,K_min,K_max,Scheme)
% Calibrate a local volatility matrix for the normalized asset X
%
% T.. expiries of the market options 
% K_norm.. normalized strikes of the market options 
% MktVol.. implied volatilities of the market options 
% threshold,MaxIter.. calibration threshold and max nb of iterations 
% Lt,Lh.. grid dimension in time and strike (Dupire)
% K_min,K_max.. min and max strikes in the discretized grid (Dupire) 
% scheme.. finite difference scheme 'f','b','cn' (Dupire)
%
% V is the calibrated local volatility matrix
% ModelVol is the model implied volatilities at the normalized strikes
% MaxErr is the vector of calibration error at each iteration

nb_iter = 1;
MaxErr(nb_iter) = 100;
%SIGMA IJ FROM THE CALIBR VIJ->C0->SIGMA IJ =? TO SIGMA OF THE MARKET ? 
%IF NOT REPEAT IT WITH ANOTHER VIJ
%USE RATIO TO FIND ANOTHER VIJ VIJ'=VIJ*RATIO
% initial guess for the LV matrix
%V S.T. LOC VOL=MARKET VOL
V = MktVol;

% forward market volatility
mkt_fwd_vol = fwd_from_spot_vol(T,MktVol);

% calibration progress
h = waitbar(0,'Calibration...');
    
while ( MaxErr(nb_iter) > threshold && nb_iter < MaxIter )
        
    % update iteration number
    %WE ITERATE EVERY TIME THE NUMBER OF ITER BEFORE CALCULATING MMMH
    nb_iter = nb_iter+1;
    
    % compute model implied volatilities
    %%HERE FCTION MODEL VOLATILITY SEE IT
    ModelVol = model_volatility_2(T,K_norm,V,Lt,Lh,K_min,K_max,Scheme);
    
    % compute max_err
    %abs(ModelVol-MktVol) IS THE ERROR
    MaxErr(nb_iter) = max(max(abs(ModelVol-MktVol)));
    waitbar(threshold/MaxErr(nb_iter));
    
    % compute model fwd vol 
    model_fwd_vol = fwd_from_spot_vol(T,ModelVol);
    %AT LAST IT WE HAVE TO EXIT NOT REUPDATE V
    
    % compute new LV parameters
    %USE RATIO TO FIND ANOTHER VIJ VIJ'=VIJ*RATIO AND THEN ITERATE
    V = V ./ model_fwd_vol .* mkt_fwd_vol; %%CHIEDERE

end

close(h);
MaxErr = MaxErr(2:nb_iter);

end
%LITTLE ERROR IN THE CODE
%FIND IT
%ONE STEP BEFORE THE LAST ITERATION
%THEN COMP FIND THE CORRECT VALUE
%BEFORE EXITING WE DO ANOTHER UPDATE WITH
 %V = V ./ model_fwd_vol .* mkt_fwd_vol;


