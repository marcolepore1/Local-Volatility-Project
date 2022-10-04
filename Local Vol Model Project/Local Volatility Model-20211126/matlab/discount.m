function DF = discount(T,r,t)
% compute model discount factor at time t, zero rates r at times T

DF = 1;

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
    
    DF = DF*exp(-r(i)*(end_t-start_t));
end

end
