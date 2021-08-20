function [ posterior, a_MLE, rho_MLE ] =NoisyBayesian_Fit(rho, noise, trials, balls, scale, responses,rareBall,commonBall,prior)
%posterior calculation for noisy  bayesian model. Rho are all possible values of rare ball weight. Noise are all values for noise variance, trial are the
%number of trials, HT are the observations of each trial, true_scale is the
%rescaling factor associated with the creationg of rho
%(1/log((1-L)/(1-H))). Responses are the observer's responses, rareBall is
%the color of the rare ball %(1 for red -1 for blue), commonBall is the color of the common ball,  
%prior is the prior (informed from pilot studies for Bayesian models. See informedPrior file) 

%noisy 
posterior=ones(length(rho),length(noise)); % initialize matrix

for j=1:trials
    
     indR=find(balls{j}==rareBall);
     
     if ~isempty(indR)
        Rcount=length(indR);
     else
         Rcount=0;
     end

     indB=find(balls{j}==commonBall);
     if ~isempty(indB)
         Bcount=length(indB);
     else
         Bcount=0;
     end
     
    n=length(balls{j});
    p_response_trial=zeros(length(rho),length(noise));

   for r=1:length(rho)
    rh=rho(r);

    for w=1:length(noise)
        wg=noise(w);
        meanZ= rh*Rcount-Bcount; % mean based on observed balls and rho
        varZ=wg*n*scale(r); %noise
        p_H=1-cdf('Normal',0,meanZ,varZ);
        p_L=cdf('Normal',0,meanZ,varZ);

        if  responses(j)==1 %if the response is high for both
            p_response_trial(r,w)=p_H;
        elseif responses(j)==-1
            p_response_trial(r,w)=p_L;
        end
    end
   end
 posterior= posterior.*  p_response_trial; 
end
posterior=posterior.*prior;
rng_post=range(posterior,'all');
thresh5=max(posterior,[],'all')-0.05*rng_post;
[rho_MLE, a_MLE]=ind2sub(size(posterior),find(posterior>thresh5));

end

