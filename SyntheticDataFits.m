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
RareThresh=1:10;

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
load informedPrior

%data sizes (for Bayes Factors and priors)
datasize_VarRare=length(Prare)*length(Pno)*length(RareThresh);
datasize_HDrare=length(Prare)*length(Pno)*length(Prare)*length(Pno);
datasize_noisy=length(rhoP)*length(weightvar);
datasize_rare=length(Prare)*length(Pno);
datasize_guess=length(Pguess);
datasize_noisyNoRho=length(weightvar);
datasize_priorNoRho=length(weightvar)*length(prior);
datasize_prior=length(rhoP)*length(weightvar)*length(prior);
datasize_window=length(rhoP)*length(weightvar)*length(windows);
%% Noisy Bayesian Fit

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %randomly select parameters
    r=randi(length(rhoP));
    rho=rhoP(r);
    scaleRho=scale(r);
    a=weightvar(randi(length(weightvar)));
    Noisy_Synth{k} = noisyBayesianModel( trials, rho ,a, scaleRho, Balls{k}, rareB,commonB); %create responses
end

for k=1:blocknum
    [ NBposterior, a_MLE, rho_MLE ] =NoisyBayesian_Fit(rhoP, weightvar, trials, Balls{k}, scale, Noisy_Synth{k},rareB,commonB,weakPrior{k});
      NBRhoMLE{k}=rhoP(rho_MLE);
      NBNoisyMLE{k}=weightvar(a_MLE);
end

%% Noisy Bayesian Set Rho Fit


for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %ideal observer rho
    rho=TR(k);
    scaleRho=logScale(k);
    a=weightvar(randi(length(weightvar)));
    NoisySetRho_Synth{k} = noisyBayesianModel( trials, rho ,a, scaleRho, Balls{k}, rareB,commonB); %create responses
end

for k=1:blocknum
     ind= find(rhoP==true_rho);
    [NSRposterior, a_MLE ] =NoisyBayesianSetRho_Fit(TR(k), weightvar, trials, Balls{k}, logScale(k), NoisySetRho_Synth{k},rareB,commonB,weakPrior{k}(ind,:));
     NSRNoisyMLE{k}=weightvar(a_MLE);
end

%% Prior Bayesian Fit

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %ideal observer rho
    rho=TR(k);
    scaleRho=logScale(k);
    a=weightvar(randi(length(weightvar)));
    pr=prior(randi(length(prior)));
    Prior_Synth{k} = priorModel( trials, rho,a, pr, scaleRho, Balls{k},rareB, commonB); %create responses
end

for k=1:blocknum
     ind= find(rhoP==true_rho);
    [Pposterior, a_MLE ] =Prior_Fit(TR(k), weightvar, prior, trials, Balls{k}, logScale(k), NoisySetRho_Synth{k},rareB,commonB,weakPrior{k}(ind,:));
     PNoisyMLE{k}=weightvar(a_MLE);
     PPriorMLE{k}=prior(p_MLE);
end

%% Windowing Fits

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

for k=1:blocknum % for each block
    [Wposterior, a_MLE, rho_MLE, wind_MLE ] = Window_Fit(rhoP, weightvar, trials, Balls{k}, scale, WindowSynth{k}, windows, rareB, commonB,weakPrior{k});
    WNoisyMLE{k}=weightvar(a_MLE);
    WWindMLE{k}=windows(wind_MLE);
    WRhoMLE{k}=rhoP(rho_MLE);
end

%% Variable Rare Ball Fits
prior_varRare=repmat(1/datasize_VarRare,[length(Prare),length(Pno),length(RareThresh)]);

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %randomly select parameters
    rare=Prare(randi(length(Prare)));
    no=Pno(randi(length(Pno)));
    rareMax=RareThresh(randi(length(RareThresh)));
    VarRareBall_Synth{k} = VarRareBallModel(rare, no, rareMax, Balls{k},  trials, rareB ); %create responses
end

for k=1:blocknum % for each block
        [VRposterior, Prare_MLE, Pno_MLE, maxRare_MLE] =VarRareBall_Fit( Prare, Pno, trials, Balls{k}, VarRareBall_Synth{k}, rareB, prior_varRare, RareThresh(end));
       prareMLE{k}=Prare(Prare_MLE);
        pnoMLE{k}=Pno(Pno_MLE);
        maxRareMLE{k}=RareThresh(maxRare_MLE);
end

%% Rare Ball Fits
prior_Rare=repmat(1/datasize_rare,[length(Prare),length(Pno)]);

for k=1:blocknum % for each block
    [Balls{k}, Jars{k} ] = observationMaker( h(k),l(k), trials, obs); %create the ball draws
    %randomly select parameters
    rare=Prare(randi(length(Prare)));
    no=Pno(randi(length(Pno)));
    RareBall_Synth{k} = rareBallModel(rare, no, Balls{k},  trials, rareB ); %create responses
end

for k=1:blocknum % for each block
        [Rposterior, Prare_MLE, Pno_MLE] =RareBall_Fit(Prare, Pno, trials, Balls{k}, RareBall_Synth{k}, rareB, prior_Rare);
       prareMLE{k}=Prare(Prare_MLE);
        pnoMLE{k}=Pno(Pno_MLE);
end

%% History Dependent Rare Ball Fits
prior_HDRare=repmat(1/datasize_HDrare,[length(Prare),length(Pno),length(Prare),length(Pno)]);

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

for k=1:blocknum % for each block
       [HDRposterior, PrareH_MLE,PrareL_MLE, PnoH_MLE, PnoL_MLE] =HDRareBall_Fit( Prare, Pno, trials, Balls{k}, HDRareBall_Synth{k},rareB,prior_HDRare);
       prareHMLE{k}=Prare(PrareH_MLE);
       pnoHMLE{k}=Pno(PnoH_MLE);
       prareLMLE{k}=Prare(PrareL_MLE);
       pnoLMLE{k}=Pno(PnoL_MLE);
end

%% Guess Fits
prior_Guess=repmat(1/datasize_guess,[length(Pguess),1]);

for k=1:blocknum % for each block
    %randomly select parameters 
    guess=Pguess(randi(length(Pguess)));
   Guess_Synth{k} = guessModel(guess,trials); %create responses
end

for k=1:blocknum % for each block
       [Gposterior, PguessH_MLE] =Guess_Fit( Pguess, trials, Guess_Synth{k}, prior_Guess );
       pguessMLE{k}=Pguess(PguessH_MLE);
end
