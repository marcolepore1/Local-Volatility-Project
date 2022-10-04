function[S] = black_simulation_log(T,Fwd,sigma,N,expiry)
		% Monte Carlo simulation for the asset S under the LV model
        % T.. LV expiries, F.. forwards at T, sigma.. Black volatility
		% N.. MC simulations, expiry.. MC time horizon
		
		logX = zeros(N,1);
        
        W = randn(N,1,length(expiry));

        for k = 1:length(expiry)
            if k==1
                dt = expiry(k);
            else
                dt = (expiry(k)-expiry(k-1));
            end
            %NB HERE:
            logX(:) = logX(:) - 0.5 * dt * sigma.^2 + sigma .* W(:,1,k) * sqrt(dt);

            fwd = interp1(T,Fwd,expiry(k));
            S(k,:) = fwd * exp(logX(:));
        end
	end

