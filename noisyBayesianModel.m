function [ Noisy_Synth] = noisyBayesianModel( trials, rho,a, scale, HT, rareB,commonB)
% creates synthetic data for either the noisy Bayesian or noisy Bayesian set rho models. trials is number of trials in block,
%rho is the rare ball weight, a is noise variance, scale is scaling associated with rho, HT is
%observations (balls drawn from observationMaker), rareB is the value
%assocaited with a rare ball observation, commonB is the value associated
%with a common ball observation

 Noisy_Synth=zeros(trials,1);
for x=1:trials
      Z=0; %inference
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
       if r>=0.5
           Noisy_Synth(x)=1;
       else
        Noisy_Synth(x)=-1; % bias toward one response
       end
   end
end
end

