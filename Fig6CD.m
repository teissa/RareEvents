load Data6CD
blocks=5;
subjects=size(BestModel,2);
blocknames={'CT','HA','HS','EA','ES'};

%% Fig 6C
for k=1:blocks
     figure; hold on;
    for s=1:subjects
       plot(MI(s,k),SubBias(k,s),'.','MarkerSize',20,'MarkerEdgeColor',clrs(BestModel(k,s),:));
    end      
    xlabel('MI','Interpreter','Latex')
     ylabel('Bias','Interpreter','Latex')
      axis([0 1 -1 10])
     set(gca, 'FontSize', 30)
      plot([0 1], [0 0], 'k:')
        
    medBiasBayes{k}=median(SubBias(k,MistunedBayesianSubs{k}));
    medBiasHeur{k}=median(SubBias(k,HeuristicSubs{k}));
    medMIBayes{k}=median(MI(MistunedBayesianSubs{k},k));
    medMIHeur{k}=median(MI(HeuristicSubs{k},k));
    medBiasNI{k}=median(SubBias(k,NearlyIdealSubs{k}));
    medMINI{k}=median(MI(NearlyIdealSubs{k},k));
    pMedMINIB{k}=ranksum(MI(NearlyIdealSubs{k},k),MI(MistunedBayesianSubs{k},k));
    pMedMINIH{k}=ranksum(MI(NearlyIdealSubs{k},k),MI(HeuristicSubs{k},k));
  
             plot(medMINI{k},medBiasNI{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(2,:))  
        if pMedMINIB{k}<0.05
             plot(medMIBayes{k},medBiasBayes{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(1,:))
         else
             plot(medMIBayes{k},medBiasBayes{k},'^','MarkerSize',25,'MarkerEdgeColor',clrs(1,:),'LineWidth',5)
        end
         
         if pMedMINIH{k}<0.05
             plot(medMIHeur{k},medBiasHeur{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(4,:))
         else
             plot(medMIHeur{k},medBiasHeur{k},'^','MarkerSize',25,'MarkerEdgeColor',clrs(4,:),'LineWidth',5)
         end
end

%% Fig 6D

for k=1:blocks
     figure; hold on;
    for s=1:subjects
       plot(MI(s,k),SubVariance(k,s),'.','MarkerSize',20,'MarkerEdgeColor',clrs(BestModel(k,s),:));
    end      
    xlabel('MI','Interpreter','Latex')
     ylabel('Variance','Interpreter','Latex')
      axis([0 1 -0.2 1.2])
     set(gca, 'FontSize', 30)
      plot([0 1], [0 0], 'k:')
        
    medBiasBayes{k}=median(SubVariance(k,MistunedBayesianSubs{k}));
    medBiasHeur{k}=median(SubVariance(k,HeuristicSubs{k}));
    medMIBayes{k}=median(MI(MistunedBayesianSubs{k},k));
    medMIHeur{k}=median(MI(HeuristicSubs{k},k));
    medBiasNI{k}=median(SubVariance(k,NearlyIdealSubs{k}));
    medMINI{k}=median(MI(NearlyIdealSubs{k},k));
    pMedMINIB{k}=ranksum(MI(NearlyIdealSubs{k},k),MI(MistunedBayesianSubs{k},k));
    pMedMINIH{k}=ranksum(MI(NearlyIdealSubs{k},k),MI(HeuristicSubs{k},k));
  
             plot(medMINI{k},medBiasNI{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(2,:))  
        if pMedMINIB{k}<0.05
             plot(medMIBayes{k},medBiasBayes{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(1,:))
         else
             plot(medMIBayes{k},medBiasBayes{k},'^','MarkerSize',25,'MarkerEdgeColor',clrs(1,:),'LineWidth',5)
        end
         
         if pMedMINIH{k}<0.05
             plot(medMIHeur{k},medBiasHeur{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(4,:))
         else
             plot(medMIHeur{k},medBiasHeur{k},'^','MarkerSize',25,'MarkerEdgeColor',clrs(4,:),'LineWidth',5)
         end
end