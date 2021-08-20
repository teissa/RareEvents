function [ posterior, PguessH_MLE ] =Guess_Fit( Pguess, trials, response, prior )
%posterior for guess model- parameter possibilities Pguess, trials=
%number of trials, response= responses from observer, prior=prior over
%parameter probabilities
posterior=ones(length(Pguess),1);

        
for x=1:trials
    
   
    resp= response(x);
    ghH=Pguess;
    ghL=1-Pguess;
    if resp==1 
        p_response_trial=ghH;
    elseif resp==-1 
        p_response_trial=ghL;

    end 
              
posterior= posterior.*  p_response_trial';  
end
posterior= posterior.*prior;  

rng_post=range(posterior);
thresh5=max(posterior)-0.05*rng_post;
PguessH_MLE=find(posterior>thresh5);
% mx_guess=max(posterior);
% PguessH_MLE=find(mx_guess==posterior);

end

