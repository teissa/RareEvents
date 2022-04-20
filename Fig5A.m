load Data5A
blocks=5;
subjects=size(BestModel,2);
blocknames={'CT','HA','HS','EA','ES'};

 for k=1:blocks
      figure; hold on;
     for s=1:subjects
        plot(SubBias(k,s),SubVariance(k,s),'.','MarkerSize',20,'MarkerEdgeColor',clrs(BestModel(k,s),:));
     end
     title(blocknames{k},'Interpreter','Latex')
     xlabel('Bias','Interpreter','Latex')
     ylabel('Variance','Interpreter','Latex')
      axis([-10 10 -0.2 1.2])
     set(gca, 'FontSize', 30)
      plot([0 0], [-1 20], 'k:')
      plot([-10 10], [0 0], 'k:')
      
     
        % medians
    medBiasBayes(k)=median(SubBias(k,MistunedBayesianSubs{k}));
    medBiasHeur(k)=median(SubBias(k,HeuristicSubs{k}));
    medBiasNio(k)=median(SubBias(k,NearlyIdealSubs{k}));
    medVarBayes(k)=median(SubVariance(k,MistunedBayesianSubs{k}));
    medVarHeur(k)=median(SubVariance(k,HeuristicSubs{k}));
    medVarNio(k)=median(SubVariance(k,NearlyIdealSubs{k}));
     pMedVarIB(k)=ranksum(SubVariance(k,MistunedBayesianSubs{k}),SubVariance(k,NearlyIdealSubs{k}));
    pMedBiasIB(k)=ranksum(SubBias(k,MistunedBayesianSubs{k}),SubBias(k,NearlyIdealSubs{k}));
     pMedVarIH(k)=ranksum(SubVariance(k,NearlyIdealSubs{k}),SubVariance(k,HeuristicSubs{k}));
    pMedBiasIH(k)=ranksum(SubBias(k,NearlyIdealSubs{k}),SubBias(k,HeuristicSubs{k}));
    
    plot(medBiasNio(k),-0.2,'^','MarkerSize',20,'MarkerEdgeColor',clrs(2,:),'MarkerFaceColor',clrs(2,:))
    plot(-10,medVarNio(k),'^','MarkerSize',20,'MarkerEdgeColor',clrs(2,:),'MarkerFaceColor',clrs(2,:))

                
        if pMedBiasIB(k)<0.05
             plot(medBiasBayes(k),-0.2,'^','MarkerSize',20,'MarkerEdgeColor',clrs(1,:),'MarkerFaceColor',clrs(1,:))
         else
             plot(medBiasBayes(k),-0.2,'^','MarkerSize',20,'MarkerEdgeColor',clrs(1,:),'LineWidth',2)
        end
        
        if pMedBiasIH(k)<0.05
             plot(medBiasHeur(k),-0.2,'^','MarkerSize',20,'MarkerEdgeColor',clrs(4,:),'MarkerFaceColor',clrs(4,:))
         else
             plot(medBiasHeur(k),-0.2,'^','MarkerSize',20,'MarkerEdgeColor',clrs(4,:),'LineWidth',2)
        end
        
        if pMedVarIB(k)<0.05
             plot(-10,medVarBayes(k),'^','MarkerSize',20,'MarkerEdgeColor',clrs(1,:),'MarkerFaceColor',clrs(1,:))
         else
             plot(-10,medVarBayes(k),'^','MarkerSize',20,'MarkerEdgeColor',clrs(1,:),'LineWidth',2)
        end  
        
        if pMedVarIH(k)<0.05
             plot(-10,medVarHeur(k),'^','MarkerSize',20,'MarkerEdgeColor',clrs(4,:),'MarkerFaceColor',clrs(4,:))
         else
             plot(-10,medVarHeur(k),'^','MarkerSize',20,'MarkerEdgeColor',clrs(4,:),'LineWidth',2)
        end

set(gca,'TickLabelInterpreter','Latex')
 end
 
 
 