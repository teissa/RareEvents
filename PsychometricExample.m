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


% ideal observer LLR values
for k=1:blocknum
    for j=1:2+1 %2 ball
    IObeliefsB2(k,j)=TR(k)*(j-1)-1*(2-(j-1));
    end
    for j=1:5+1 %5 ball
    IObeliefsB5(k,j)=TR(k)*(j-1)-1*(5-(j-1));
    end
    for j=1:10+1 %10 ball
    IObeliefsB10(k,j)=TR(k)*(j-1)-1*(10-(j-1));
    end
    IObeliefs{k}=[IObeliefsB2(k,:),IObeliefsB5(k,:),IObeliefsB10(k,:)];
    IObeliefs{k}=unique(IObeliefs{k});
end
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
    
   
      for t=1:length(Balls{k})
        rares=sum(Balls{k}{t}==rareB);
        commons=sum(Balls{k}{t}==commonB);
        Z(t)=TR(k)*rares-commons;
      end
    Noisy_Synth{k}(Noisy_Synth{k}==-1)=0; %converted to responses for the high jar only


    DataNb{k}=[Z', Noisy_Synth{k}];
    fitsNb{k} = logist_fit(DataNb{k}); 
end

%% bias, variance, noise
for k=1:blocknum
     bias(:,k)=fitsNb{k}(:,2); %horizontal shift
     noise(:,k)=abs(1./fitsNb{k}(:,1)); %inverse slope
     
     %compute mean absolute error
    ucohs = unique(DataNb{k}(:,1));
    cdat = nan*zeros(length(ucohs), 2);
    Lr = DataNb{k}(:,2) == 1;
    ft=logist_val(fitsNb{k}(:)', ucohs);
    for cc = 1:length(ucohs)
        Lc = DataNb{k}(:,1) == ucohs(cc);
        cdat(cc,:) = [sum(Lc&Lr)./sum(Lc), sum(Lc)];
        ind=find(IObeliefs{k}==ucohs(cc));
    end
    ResidNb{k}=abs(cdat(:,1)-ft); %absolute residuals
    WeightResidNb{k}=ResidNb{k}.*cdat(:,2); %weighted by number of points
    variance(k)=mean(WeightResidNb{k}); %mean absolute error
end

