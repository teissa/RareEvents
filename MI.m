function [MIn, Nfr] = MI(features, responses)
%Log2 empirical mututal information

  uF = unique(features);
  uR = unique(responses);
  
      for k=1:length(uF)%features
           for r=1:length(uR) %responses
               Nfr(k,r)=sum(features==uF(k)&  responses==uR(r));  
           end
       end
         
       Nr=sum(Nfr);
       Nf=sum(Nfr,2);  
      
       N = sum(Nfr(:));

       I=zeros(length(uF),length(uR)); 
    
      for k=1:length(uF)
          for r=1:length(uR)
              I(k,r)=I(k,r)+(Nfr(k,r)/N)*log2((Nfr(k,r)*N)/(Nr(r)*Nf(k)));   
          end
      end
       
      
       
       I(isnan(I))=0;
      

       MIn=sum(sum(I));

end

