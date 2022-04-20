load Data6B
blocks=5;
subjects=size(BestModel,2);
blocknames={'CT','HA','HS','EA','ES'};

for k=1:blocks
     figure; hold on;
    for s=1:subjects
       plot(MI(s,k),meanSubAcc(s,k),'.','MarkerSize',20,'MarkerEdgeColor',clrs(BestModel(k,s),:));
    end      
    plot(miScale,IdealObserverBound(:,k),'LineWidth',3,'Color','k')
    plot([0 1],[IdealObserverBound(end,k) IdealObserverBound(end,k)],'k--')
    xlabel('MI','Interpreter','Latex')
    ylabel('Accuracy','Interpreter','Latex')
        title(blocknames{k},'Interpreter','Latex')
    set(gca,'FontSize',30)
        set(gca,'TickLabelInterpreter','Latex')
        axis([0 1 0 1])
        
    medAccBayes{k}=median(meanSubAcc(MistunedBayesianSubs{k},k));
    medAccHeur{k}=median(meanSubAcc(HeuristicSubs{k},k));
    medMIBayes{k}=median(MI(MistunedBayesianSubs{k},k));
    medMIHeur{k}=median(MI(HeuristicSubs{k},k));
    medAccNI{k}=median(meanSubAcc(NearlyIdealSubs{k},k));
    medMINI{k}=median(MI(NearlyIdealSubs{k},k));
    pMedMINIB{k}=ranksum(MI(NearlyIdealSubs{k},k),MI(MistunedBayesianSubs{k},k));
    pMedMINIH{k}=ranksum(MI(NearlyIdealSubs{k},k),MI(HeuristicSubs{k},k));
    pMedAccNIH{k}=ranksum(meanSubAcc(HeuristicSubs{k},k),meanSubAcc(NearlyIdealSubs{k},k));
    pMedAccNIB{k}=ranksum(meanSubAcc(NearlyIdealSubs{k},k),meanSubAcc(MistunedBayesianSubs{k},k));

             plot(medMINI{k},medAccNI{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(2,:))  
        if pMedMINIB{k}<0.05
             plot(medMIBayes{k},medAccBayes{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(1,:))
         else
             plot(medMIBayes{k},medAccBayes{k},'^','MarkerSize',25,'MarkerEdgeColor',clrs(1,:),'LineWidth',5)
        end
         
         if pMedMINIH{k}<0.05
             plot(medMIHeur{k},medAccHeur{k},'^','MarkerSize',25,'MarkerEdgeColor','k','MarkerFaceColor',clrs(4,:))
         else
             plot(medMIHeur{k},medAccHeur{k},'^','MarkerSize',25,'MarkerEdgeColor',clrs(4,:),'LineWidth',5)
         end
end