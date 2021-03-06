%This code sets up the parameters and runs an example of synthetic data
%for each inference model. 

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

%heuristic probabilities
Prare=hL;
Pno=Prare;
Pguess=hL;

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


% window of balls
windows=2:1:20;
prior=-1:0.1:1;

%ball definitions
rareB=1;
commonB=-1;

%% Noisy Bayesian

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %randomly select parameters
    r=randi(length(rhoP));
    rho=rhoP(r);
    scaleRho=scale(r);
    a=weightvar(randi(length(weightvar)));
    Noisy_Synth{k} = noisyBayesianModel( trials, rho ,a, scaleRho, Balls{k}, rareB,commonB); %create responses
end

%% Noisy Bayesian Set Rho

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %ideal observer rho
    rho=TR(k);
    scaleRho=logScale(k);
    a=weightvar(randi(length(weightvar)));
    NoisySetRho_Synth{k} = noisyBayesianModel( trials, rho ,a, scaleRho, Balls{k}, rareB,commonB); %create responses
end

%% Prior Bayesian

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %ideal observer rho
    rho=TR(k);
    scaleRho=logScale(k);
    a=weightvar(randi(length(weightvar)));
    pr=prior(randi(length(prior)));
    Prior_Synth{k} = priorModel( trials, rho,a, pr, scaleRho, Balls{k},rareB, commonB); %create responses
end

%% Windowing

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %randomly select parameters
    r=randi(length(rhoP));
    rho=rhoP(r);
    scaleRho=scale(r);
    a=weightvar(randi(length(weightvar)));
    wnd=windows(randi(length(windows)));
   Window_Synth{k} = windowModel(trials, rho, a, wnd, scaleRho, Balls{k}, rareB, commonB); %create responses
end

%% Rare Ball

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %randomly select parameters
    rare=Prare(randi(length(Prare)));
    no=Pno(randi(length(Pno)));
    RareBall_Synth{k} = rareBallModel(rare, no, Balls{k},  trials, rareB ); %create responses
end

%% History- Dependent Rare Ball

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %randomly select parameters for each type fo trial and previous
    %response
    rareH=Prare(randi(length(Prare))); % e.g. rare ball trial, last response high
    noH=Pno(randi(length(Pno)));
    rareL=Prare(randi(length(Prare)));
    noL=Pno(randi(length(Pno)));
    HDRareBall_Synth{k} = HDrareBallModel( rareH,rareL, noH,noL, Balls{k},  trials, rareB ); %create responses
end

%% Guess Model

for k=1:blocknum % for each block
    %randomly select parameters 
    guess=Pguess(randi(length(Pguess)));
   Guess_Synth{k} = guessModel(guess,trials); %create responses
end