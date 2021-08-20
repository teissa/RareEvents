function [ posterior, Prare_MLE, Pno_MLE, maxRare_MLE ] =VarRareBall_Fit( Prare, Pno, trials, HT, response, rareBall,prior, maxRare )
%posterior for variable rare ball model- parameter possibilities for p rare (Prare)
%and Pno, trials in block, and HT are observations, responses are the
%observer's response to each trial, rareBall is the color of the rare ball
%(1 for red -1 for blue), prior is the prior (flat for heuristics), maxRAre
%is the max rare ball threshold

posterior=ones(length(Prare), length(Prare),maxRare+1);
    for x=1:trials

        %if rare exists in trial
         if ~isempty(find(HT{x}==rareBall,1))
            Rcount=length(find(HT{x}==rareBall));
         else
             Rcount=0;
         end

        resp= response(x);
         for mr=1:maxRare+1
            p_response_trial=zeros(length(Prare), length(Prare));
           for rr=1:length(Prare)
                rhH=Prare(rr);
                rhL=1-Prare(rr);

                for w=1:length(Pno)
                    nhH=Pno(w);
                    nhL=1-Pno(w);
                    if resp==1 && Rcount>=mr-1 %response high for both
                        p_response_trial(rr,w)=rhH;
                    elseif resp==1 && Rcount<mr-1
                        p_response_trial(rr,w)=nhH;
                    elseif resp==-1 && Rcount>=mr-1
                        p_response_trial(rr,w)=rhL;
                    elseif resp==-1 && Rcount<mr-1
                        p_response_trial(rr,w)=nhL;
                    end 

                end
           end
            posterior(:,:,mr)= posterior(:,:,mr).*  p_response_trial; 

         end

    end
posterior=posterior.*prior;

%find parameters in to 95% of posterior
rng_post=range(posterior,'all');
thresh5=max(posterior,[],'all')-0.05*rng_post;
[Prare_MLE, Pno_MLE, maxRare_MLE]=ind2sub(size(posterior),find(posterior>thresh5));



end

