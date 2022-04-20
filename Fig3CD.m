load Data3CD
blocknames={'CT','HA','HS','EA','ES'};
subjects=size(SubMeanRespHigh{1},1);
blocks=5;

for k=1:blocks
    figure; hold on
    for s=1:length(SubjectSubset{k})
    plot(LLRs{k},SubMeanRespHigh{k}(SubjectSubset{k}(s),:),'k.','MarkerSize',15); 
     y=logist_val_tahra(SubPsychometricFits{k}(SubjectSubset{k}(s),:)', LLRs{k});
     plot(LLRs{k},y,'k'); 
    end
     ylim([0 1])
     set(gca,'FontSize',30)
     xlabel('LLR','Interpreter','Latex')
     ylabel('Respond High','Interpreter','Latex')
     title(blocknames{k},'Interpreter','Latex')
end

