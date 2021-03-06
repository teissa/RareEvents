function [ Rare_Ball_Synth] = rareBallModel( Prare, Pno, HT,  trials, rareB )
%creates synthetic data for the rare ball model. Prare and Pno are the
%probability of giving high or low jar respectively while seeing (or not
%seeing a rare ball), ht are observations, trials is the nubmer of trials

  Rare_Ball_Synth=zeros(trials,1);
   
     for x=1:trials
        indR=find(HT{x}==rareB);
        rn=rand;
       if ~isempty(indR) && rn<=Prare
            Rare_Ball_Synth(x)=1;
       elseif ~isempty(indR) && rn> Prare
           Rare_Ball_Synth(x)=-1;
       elseif isempty(indR) && rn<= Pno
            Rare_Ball_Synth(x)=1;
       elseif isempty(indR) && rn> Pno
            Rare_Ball_Synth(x)=-1;  
       end

     end

end

