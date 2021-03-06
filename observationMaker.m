function [ HT, true_coin ] = observationMaker( H,L, trials, observations )
%ObservationMaker builds sequences of ball draws. H and L are the rare ball probabilities of the high (H) and low (L) jars.
%Trials is number of trials in a block. Observations are the number
%of possible draws on a given trial. this creates data for a single block
%at a time   
    
    % sets individual trial parameters 
    hp_trials=randperm(trials,trials/2);
    true_coin=zeros(1,trials);
    true_coin(hp_trials)=1;
    true_coin(true_coin~=1)=-1;
    hm_trials=find(true_coin~=1);
    r_hm=randperm(length(hm_trials)); 
    hm_trials=hm_trials(r_hm);
    obs_number=zeros(1,trials);
    
    obs_number(hp_trials(1:trials/6))=observations(1);
    obs_number(hm_trials(1:trials/6))=observations(1);
    obs_number(hp_trials(trials/6+1:2*trials/6))=observations(2);
    obs_number(hm_trials(trials/6+1:2*trials/6))=observations(2);
    obs_number(hp_trials(2*trials/6+1:3*trials/6))=observations(3);
    obs_number(hm_trials(2*trials/6+1:3*trials/6))=observations(3);

    %structure task observations
    HT=cell(trials,1);
    for m=1:trials 
    draws=obs_number(m);

     if true_coin(m)>0
        jar=H;
     elseif true_coin(m)<0
        jar=L;
     end

       for y=1:draws

            r=rand; %random selection ball
            if r<jar %1= heads
                HT{m}(y)=1;
            else
                HT{m}(y)=-1;
            end

       end 
    end
end

