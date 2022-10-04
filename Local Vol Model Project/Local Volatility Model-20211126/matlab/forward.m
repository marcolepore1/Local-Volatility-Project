function Fwd = forward(Spot,T,r,q,t)
% compute model forward at time t, given asset's spot, zero rates r and
% dividend yields q at expiry times T

Fwd = Spot;

i_max = find(T>=t,1);
if isempty(i_max) 
    i_max = length(T);
end;

for i=1:i_max
    
    if i==1
        start_t = 0;
    else
        start_t = T(i-1);
    end
    
    if i<length(T)
        end_t = min(T(i),t);
    else
        end_t = t;
    end
    
    Fwd = Fwd*exp((r(i)-q(i))*(end_t-start_t));    
end

end
