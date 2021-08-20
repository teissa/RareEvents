function [ posterior, PrareH_MLE,PrareL_MLE, PnoH_MLE, PnoL_MLE] =HDRareBall_Fit( Prare, Pno, trials, HT, response,rareBall,prior )
%posterior for history dependent rare ball model- parameter possibilities for Prare
%and Pno, trials in block, and HT are observations, responses are the
%observer's response to each trial, rareBall is the color of the rare ball
%(1 for red -1 for blue), prior is the prior (flat for heuristics), 

posterior=ones(length(Prare),length(Prare),length(Prare),length(Prare));
for x=1:trials
    if x<2
       p_response_trial=ones(length(Prare),length(Prare),length(Prare),length(Prare));
       posterior= posterior.*  p_response_trial;  
    else
        %if red exists in trial
         if ~isempty(find(HT{x}==rareBall,1))
            Rcount=1;
         else
             Rcount=0;
         end

        resp= response(x);
        resp1=response(x-1);
        p_response_trial=zeros(length(Prare),length(Prare),length(Prare),length(Prare));

       for rh=1:length(Prare)
            rH=Prare(rh);
            rHopp=1-Prare(rh);
            
            for rl=1:length(Prare)
                 rL=Prare(rl);
                 rLopp=1-Prare(rl);

                  for nh=1:length(Pno)
                     nH=Pno(nh);
                     nHopp=1-Pno(nh);
                     
                     for nl=1:length(Pno)
                        nL=Pno(nl);
                    	nLopp=1-Pno(nl);
                     
                        if resp==1 && Rcount==1 && resp1==1 %red ball, respond high, last high
                            p_response_trial(rh,rl,nh,nl)=rH;
                        elseif resp==-1 && Rcount==1 && resp1==1 %red ball, respond low, last high
                            p_response_trial(rh,rl,nh,nl)=rHopp;
                        elseif resp==1 && Rcount==1 && resp1==-1 %red ball, respond high, last low
                            p_response_trial(rh,rl,nh,nl)=rL;
                        elseif resp==-1 && Rcount==1 && resp1==-1 %red ball, respond low, last low
                            p_response_trial(rh,rl,nh,nl)=rLopp;
                            
                        elseif resp==-1 && Rcount==0 && resp1==1 %no ball, respond low, last high
                            p_response_trial(rh,rl,nh,nl)=nH;
                        elseif resp==1 && Rcount==0 && resp1==1 %no ball, respond high, last high
                            p_response_trial(rh,rl,nh,nl)=nHopp;
                        elseif resp==-1 && Rcount==0 && resp1==-1 %no ball, respond low, last low
                            p_response_trial(rh,rl,nh,nl)=nL;
                        elseif resp==1 && Rcount==0 && resp1==-1 % no ball, respond high, last low
                            p_response_trial(rh,rl,nh,nl)=nLopp;   
                        end 
                     end
                  end
            end
       end
    posterior= posterior.*  p_response_trial; 
    end
end
    posterior= posterior.*  prior; 

rng_post=range(posterior,'all');
thresh5=max(posterior,[],'all')-0.05*rng_post;
[PrareH_MLE, PrareL_MLE, PnoH_MLE, PnoL_MLE]=ind2sub(size(posterior),find(posterior>thresh5));


end

