function [ k, D, t ] = solve_dupire_2( T, K, V, Expiry, Lt, Lh, K_min, K_max, Scheme)
% Solve Dupire equation for a normalized asset X up to Expiry
%
% T.. LV expiries, K.. LV nodes, V.. LV matrix
% Expiry.. expiry of the call options 
% Lt,Lh.. grid dimension in time and strike
% K_min,K_max.. min and max strikes in the discretized grid 
% scheme.. finite difference scheme 'f','b','cn'
%
% C(i) = price of a call option on X with strike k(i)=exp(h(i)) 
%        and expiring at Expiry

% create time and strike grid
t = linspace(0,Expiry,Lt);
h = linspace(log(K_min),log(K_max),Lh);
k = exp(h);

dt = t(2)-t(1);
I = eye(Lh);
C = max(0,1-exp(h))';
%D = max(0,1-exp(h))';
%C_0 = C;

if strcmp(Scheme,'f')
    % forward scheme
    i=1;
    A = build_A(T,K,V,t(i),h);
    C = (I-dt*A)*C;
    D = C;
    for i=2:length(t)
    	A = build_A(T,K,V,t(i),h);
        C = (I-dt*A)*C;
        D = [D,C];
    end
elseif strcmp(Scheme,'b')
    % backward scheme 
    i=1;
    A = build_A(T,K,V,t(i+1),h);
    C = (I+dt*A)\C;
    D=C;
    for i=2:length(t)-1
    	A = build_A(T,K,V,t(i+1),h);
        C = (I+dt*A)\C;
        D = [D,C];
    end    
elseif strcmp(Scheme,'cn')
    % Crank-Nicolson scheme 
    i=1;
    A = build_A(T,K,V,t(i),h);
    Ap = build_A(T,K,V,t(i+1),h);
    C = (I+0.5*dt*Ap)\( (I-0.5*dt*A)*C );
    D=C;
    for i=2:length(t)-1
    	A = build_A(T,K,V,t(i),h);
    	Ap = build_A(T,K,V,t(i+1),h);
        C = (I+0.5*dt*Ap)\( (I-0.5*dt*A)*C );
        D = [D,C];
    end
end

end

