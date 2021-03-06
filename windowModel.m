function [Noisy_Synth] = windowModel(trials, rho,a,wnd, scaleRho, Balls, rareB, commonB)
%creates synthetic data for the windowing model. Trials is the number of
%trials, rho is the rare ball weight, a is noise, scale is scaling associated with rho, HT is
%observations (balls drawn from observationMaker), rareB is the value
%associated with a rare ball observation, commonB is the value associated
%with a common ball observation, window is the number of observations used
Noisy_Synth=zeros(trials,1);
for x=1:trials
    
    balls=[];
    if x<5
        for k=1:x
            balls=[balls, Balls{k}];
        end
    else
        for k=x-4:x
        balls=[balls, Balls{k}];
        end 
    end
    
    if length(balls)< wnd
         Z=0; %inference
            for y=1:length(balls)
                wn=randn*scaleRho;
                if balls(y)==rareB
                    Z=rho+wn*a+Z;
                elseif balls(y)==commonB
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
    else
        ballWindow=balls(end-(wnd-1):end);
         Z=0; %inference
            for y=1:length(ballWindow)
                wn=randn*scaleRho;
                 %determine heads or tails
                if ballWindow(y)==1 %1= heads
                    Z=rho+wn*a+Z;
                elseif ballWindow(y)==-1
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
end

