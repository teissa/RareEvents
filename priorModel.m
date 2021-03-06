function [ Noisy_Synth] = priorModel( trials, rho,a, prior, scale, HT, rareB, commonB)
% creates synthetic data for the prior Bayesian model. trials is number of trials in block,
%rho is the rare ball weight, a is noise, scale is scaling associated with rho, HT is
%observations (balls drawn from observationMaker), rareB is the value
%assocaited with a rare ball observation, commonB is the value associated
%with a common ball observation, prior is the initial bias which is scaled
%by the rare ball weight

 Noisy_Synth=zeros(trials,1);
for x=1:trials
      Z=prior*rho; %inference
    for y=1:length(HT{x})
        wn=randn*scale;
        if HT{x}(y)==rareB
            Z=rho+wn*a+Z;
        elseif HT{x}(y)==commonB
            Z=-1+wn*a+Z;
        end
    end

   if Z> 0
        Noisy_Synth(x)=1;
   elseif Z<0 
        Noisy_Synth(x)=-1;
   else
       r=rand;
       if r>0.5
           Noisy_Synth(x)=1;
       else
        Noisy_Synth(x)=-1; % bias toward one response
       end
   end
end
end

