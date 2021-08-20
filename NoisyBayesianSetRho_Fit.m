function [ posterior, a_MLE ] =NoisyBayesianSetRho_Fit(true_rho, noise, trials, HT, true_scale, responses,rareBall,commonBall,prior)
%posterior calculation for noisy  bayesian model with rho set to the true
%rho (true_rho). Noise are all values for noise variance, trial are the
%number of trials, HT are the observations of each trial, true_scale is the
%rescaling factor associated with the creationg of rho
%(1/log((1-L)/(1-H))). Responses are the observer's responses, rareBall is
%the color of the rare ball %(1 for red -1 for blue), commonBall is the color of the common ball,  
%prior is the prior (informed from pilot studies for Bayesian models. See informedPrior file) 

%noisy 
posterior=ones(1,length(noise));
for j=1:trials
     indR=find(HT{j}==rareBall);
     
     if ~isempty(indR)
     Rcount=length(indR);
     else
         Rcount=0;
     end

     indB=find(HT{j}==commonBall);
     if ~isempty(indB)
         Bcount=length(indB);
     else
         Bcount=0;
     end
    n=length(HT{j});
    p_response_trial=zeros(1,length(noise));



    for w=1:length(noise)
        wg=noise(w);
        meanZ= true_rho*Rcount-Bcount;
        varZ=wg*n*true_scale;
        p_H=1-cdf('Normal',0,meanZ,varZ);
        p_L=cdf('Normal',0,meanZ,varZ);

        if  responses(j)==1 %response high for both
            p_response_trial(w)=p_H;
        elseif responses(j)==-1
            p_response_trial(w)=p_L;
        end
    end
 posterior= posterior.*  p_response_trial; 
end
 posterior= posterior.* prior; 
rng_post=range(posterior,'all');
thresh5=max(posterior,[],'all')-0.05*rng_post;
a_MLE=find(posterior>thresh5);


end

