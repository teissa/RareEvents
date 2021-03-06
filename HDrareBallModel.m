function [ Rare_Ball_Synth] = HDrareBallModel( PrareH,PrareL, PnoH,PnoL, HT,  trials, rareB )
%creates synthetic data for the history dependent rare ball model. Prare and Pno are the
%probability of giving high or low jar respectively while seeing (or not
%seeing a rare ball), ht are observations (balls drawn) from
%observationMaker. trials is the number of trials. 

  Rare_Ball_Synth=zeros(trials,1);
   
     for x=1:trials
         if x<2
             r=rand;
             if r<0.5
                 Rare_Ball_Synth(x)=-1;
             else
                 Rare_Ball_Synth(x)=1;
             end
         else
             
              if ~isempty(find(HT{x}==rareB,1))
                Rcount=1;
             else
                 Rcount=0;
              end
             resp1=Rare_Ball_Synth(x-1);
             rn=rand;
            
            
             if  Rcount==1 && resp1==1 %red ball, last high
                 if rn<= PrareH
                     Rare_Ball_Synth(x)=1;
                 else
                     Rare_Ball_Synth(x)=-1;
                 end
             elseif Rcount==1 && resp1==-1 %red ball, last low
                 if rn<= PrareL
                     Rare_Ball_Synth(x)=1;
                 else
                     Rare_Ball_Synth(x)=-1;
                 end
            elseif Rcount==0 && resp1==1 %no ball,  last high
                if rn<= PnoH
                     Rare_Ball_Synth(x)=1;
                 else
                     Rare_Ball_Synth(x)=-1;
                end
            elseif  Rcount==0 && resp1==-1 %no ball, last low
                 if rn<= PnoL
                     Rare_Ball_Synth(x)=1;
                 else
                     Rare_Ball_Synth(x)=-1;
                 end  
             end
             
         end

     end

end

