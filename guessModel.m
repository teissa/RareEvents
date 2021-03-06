function [Noisy_Synth] = guessModel(pguess,trials)
% creates synthetic responses from the guessing model. pguess= probability
% the high jar is guessed on any trial. trials= number of trials
Noisy_Synth=zeros(trials,1);
for x=1:trials
    rn=rand;
    if rn<=pguess
        Noisy_Synth(x)=1;
    else
        Noisy_Synth(x)=-1;
    end
end

end

