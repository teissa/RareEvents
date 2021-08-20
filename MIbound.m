%
% maxpa_nobs.m
%
% for a single observation of a bernoulli process chosen from one of two
% with a high or low success rate, finds the curve of maximal predictive
% accuracy for a fixed complexity.

clear 

pH = 0.9;
pL = 0.1;
n = 2;

ms = [0:n]';

qH = (pH*(1-pL)).^ms*(1-pH)^n./((pH*(1-pL)).^ms*(1-pH)^n+(pL*(1-pH)).^ms*(1-pL)^n);
qL = (pL*(1-pH)).^ms*(1-pL)^n./((pL*(1-pH)).^ms*(1-pL)^n+(pH*(1-pL)).^ms*(1-pH)^n);
b = (binopdf(ms,n,pH)+binopdf(ms,n,pL))/2;

% computing bounding stats for the ideal observer
mh = n*log((1-pL)/(1-pH))/log(pH*(1-pL)/pL/(1-pH)); % threshold number of red balls for high decision
% maximal possible accuracy of the IO model
bH = binopdf(ms,n,pH); bL = binopdf(ms,n,pL);
if isinteger(mh)
    amax = (sum(bH(ms>mh))+sum(bL(ms<mh)))/2+(bH(ms==mh)+bL(ms==mh))/4;
else
    amax = (sum(bH(ms>mh))+sum(bL(ms<mh)))/2;
end
% choice behavior of the IO model
aio = heaviside(ms-mh); ip = b'*aio;
mio = 0;
for j=1:n+1
    if ms(j)>mh,    mio = mio+b(j)*log2(1/ip); end
    if ms(j)==mh,   mio = mio+b(j)*(log2(1/2/ip)/2+log2((1-aio)/(1-ip))/2); end
    if ms(j)<mh,   mio = mio+b(j)*log2(1/(1-ip)); end
end

f = @(a) -b'*(a.*qH+(1-a).*qL);

Cs = linspace(0,1,100)';
Vs = zeros(length(Cs),1);
ai = 0.5*ones(n+1,1);
figure(1), hold on, plot(Cs,0*Cs+amax,'k','linewidth',2);
%  hold on, plot([mio; mio],[0 1],'k','linewidth',2);
set(gca,'fontsize',30);
xlabel('MI','fontsize',30,'interpreter','latex');
ylabel('Acc','fontsize',30,'interpreter','latex');

for j=1:length(Cs)
    
    p = [pH;pL];
    options=optimoptions('fmincon','Display','off');
    [ai,Vopt] = fmincon(@(a) f(a),ai,[],[],[],[],zeros(n+1,1),ones(n+1,1),@(a) mi_cstr(a,b,Cs(j)),options);
    Vs(j) = -Vopt;
%     figure(1), hold on, plot(Cs(j),Vs(j),'k.','markersize',50);
    
end
hold on, plot(Cs,Vs,'linewidth',8);

function [c,ceq] = mi_cstr(a,b,cmp)
% Nonlinear inequality constraints (none)
c = [];
% Nonlinear equality constraints (mutual information constraint)
ceq = b'*(a.*log2(a/(b'*a))+(1-a).*log2((1-a)/(1-b'*a)))-cmp;

end