function [ posterior, a_MLE, rho_MLE, bias_MLE ] = Window_Fit(rho, noise, trials, HT, scale, responses, windows, rareBall, commonBall,prior)
%posterior calculation for windowing model.rhoa re all rho possible values, Noise are all values for noise variance, pr are the possible biased priors, trial are the
%number of trials, HT are the observations of each trial, scale is the
%rescaling factor associated with the creationg of rho
%(1/log((1-L)/(1-H))). Responses are the observer's responses, windows are the possible window sizes, rareBall is
%the color of the rare ball %(1 for red -1 for blue), commonBall is the color of the common ball,  
%Prior is the prior with respect to rho and noise (informed from pilot studies for Bayesian models. See informedPrior file) 


posterior=ones(length(rho),length(noise),length(windows));
for b=1:length(windows)
    ws=windows(b);
for j=1:trials
    bls=[];
    for k=1:j
        bls=[bls; HT{k}'];
    end
    
    if length(bls)< ws
        ballWindow=bls;

    else
        ballWindow=bls(end-(ws-1):end);
    end
    
        indR=find(ballWindow==rareBall);
         if ~isempty(indR)
         Rcount=length(indR);
         else
             Rcount=0;
         end

         indB=find(ballWindow==commonBall);
         if ~isempty(indB)
             Bcount=length(indB);
         else
             Bcount=0;
         end
        p_response_trial=zeros(length(rho),length(noise));

       for r=1:length(rho)
        rh=rho(r);

        for w=1:length(noise)
           wg=noise(w);
            meanZ= rh*Rcount-Bcount;
            varZ=wg*ws*scale(r);
            p_H=1-cdf('Normal',0,meanZ,varZ);
            p_L=cdf('Normal',0,meanZ,varZ);

            if  responses(j)==1 %response high for both
                p_response_trial(r,w)=p_H;
            elseif responses(j)==-1
                p_response_trial(r,w)=p_L;
            end
        end
       end
     posterior(:,:,b)= posterior(:,:,b).*  p_response_trial; 
end
     posterior(:,:,b)= posterior(:,:,b).*prior; 

end



rng_post=range(posterior,'all');
thresh5=max(posterior,[],'all')-0.05*rng_post;
[rho_MLE, a_MLE,bias_MLE]=ind2sub(size(posterior),find(posterior>thresh5));

end

