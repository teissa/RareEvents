 % this code exemplifies the ideal observer's iterative process for both
 % symmetric and asymmetric environments. 
 
bls=[-1,1,-1,-1,-1,1,-1,1,-1,-1]; %observations (balls)

%probability of a rare ball
h_highS=0.55; %symmetric environment
h_lowS=0.45; %symmetric environment
h_highA=0.2; %asymmetric environment
h_lowA=0.1; %asymmetric environment

%LLRs
logRedS=round(log(h_highS/h_lowS),4);
logBlueS=round(log((1-h_highS)/(1-h_lowS)),4);
logRedA=round(log(h_highA/h_lowA),4);
logBlueA=round(log((1-h_highA)/(1-h_lowA)),4);

%priors
Z_SS(1)=0; %symmetric prior symmetric environment
Z_AS(1)=0; %symmetric prior asymmetric environment

%iterative belief process
for y=1:length(bls)
   %determine ball color
    if bls(y)==1 %rare ball
        Z_SS(y+1)=Z_SS(y)+logRedS;
        Z_AS(y+1)=Z_AS(y)+logRedA;
    elseif bls(y)==-1
        Z_SS(y+1)=Z_SS(y)+logBlueS;
        Z_AS(y+1)=Z_AS(y)+logBlueA;
    end
end
             
              
figure; hold on; plot(Z_SS,'Color',Sym,'LineWidth',4); 
plot(Z_AS,'Color',Asym,'LineWidth',4);
plot([1 11],[0 0],'k'); xlim([1 11])
              


