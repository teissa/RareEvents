function [ Rare_Ball_Synth] = VarRareBallModel( Prare, Pno, rareMax, HT,  trials, rareBall )
%creates synthetic data for the rare ball. Prare and Pno are the
%probability of giving high or low jar respectively while seeing (or not
%seeing a rare ball), ht are observations,
%rareMax is the threshold for rare response

  Rare_Ball_Synth=zeros(trials,1);
   
     for x=1:trials
        indR=find(HT{x}==rareBall);
        indR=length(indR);
        rn=rand;
       if indR>=rareMax && rn<=Prare
            Rare_Ball_Synth(x)=1;
       elseif indR>=rareMax && rn> Prare
           Rare_Ball_Synth(x)=-1;
       elseif indR<rareMax && rn<= Pno
            Rare_Ball_Synth(x)=1;
       elseif indR<rareMax && rn> Pno
            Rare_Ball_Synth(x)=-1;  
       end

     end

end

