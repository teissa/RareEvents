% blocks
blocknum=5;
trials=42;
obs=[2,5,10];
%block parameters
h=[0.9,0.2,0.55,0.4,0.7]; %high jar
l=[0.1,0.1,0.45,0.1,0.3]; %low jar

%all possible jar ratios
hH=0.05:0.05:1;
hL=0.05:0.05:1;

% noise values
weightvar=0.01:0.02:1;

% calculates the possible rho and scaling values
count=1;
for k=1:length(hH)
    H=hH(k);
    for j=1:length(hL)
        L=hL(j);
        logHigh=round(log(H/L),8);
        logLow=round(log((1-H)/(1-L)),8);
       logScale=1/round(log((1-L)/(1-H)),8);
        if L<H   
            scale(count)=logScale;
            lower(count)=logScale*logLow;
            rhoP(count)=logHigh*scale(count);
            hs(count)=H;
            ls(count)=L;
           count=count+1;
        end
    end
end

%identifies the ideal observer's rho value for each block
for k=1:length(h)
    H=h(k);
    L=l(k);
    logHigh=round(log(H/L),8);
    logScale(k)=1/round(log((1-L)/(1-H)),8);
    TR(k)=logHigh*logScale(k);
end
[~,uni]=unique(rhoP);
uni(rhoP(uni)==0)=[];
uni(isnan(rhoP(uni)))=[];
rhoP=rhoP(uni);
scale=scale(uni);


%ball definitions
rareB=1;
commonB=-1;

%% Noisy Bayesian  Data
tl=[2,5,10]; %trial length
rl=2; %response length
rs=[0:tl(1),0:tl(2),0:tl(3)]; %rare vector
cs=[tl(1):-1:0,tl(2):-1:0,tl(3):-1:0]; %common vector
as=[-1,1]; %response options

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %randomly select parameters
    r=randi(length(rhoP));
    rho=rhoP(r);
    scaleRho=scale(r);
    a=weightvar(randi(length(weightvar)));
    Noisy_Synth{k} = noisyBayesianModel( trials, rho ,a, scaleRho, Balls{k}, rareB,commonB); %create responses
    
   
      
       Acc(k)=sum(Jars{k}'==Noisy_Synth{k})/trials;

       for t=1:trials
           rares(t)=length(find(Balls{k}{t}==rareB));
           commons(t)=length(find(Balls{k}{t}==commonB));
       end

    % MI using only trial based observations
       states=zeros(trials,1);
       for b=1:length(rs)
           ind=find(rares==rs(b)& commons==cs(b));
           states(ind)=b;
       end

       [NBmi(k), Nfr{k}] = MI(states,Noisy_Synth{k});
       
       %MI using trial based observations and previous response
       cur=Noisy_Synth{k}(2:end)';
       prev=Noisy_Synth{k}(1:end-1)';

       for t=2:trials
           rares(t-1)=length(find(Noisy_Synth{k}{t}==rareB));
           commons(t-1)=length(find(Noisy_Synth{k}{t}==commonB));
       end

       
       statesR=zeros(trials-1,1);

       count=1;
       for rr=1:length(rs)%features
           for r=1:rl %previous responses
                ind=find(rares==rs(rr)& commons==cs(rr) & prev==as(r));
                statesR(ind)=count;
              count=count+1;
           end
       end
       
       [NBmiR(k) , Nfr{k}]= MI(statesR,cur);
end





