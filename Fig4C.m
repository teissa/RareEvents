load Data4C
modelnames={'noisy', 'set $\rho$','Prior','Var','Rare','Guess'};
blocks=5;
subjects=size(BFs,2);

figure; hold on;
for b=1:blocks
    for s=1:subjects
      plot(BFs{b,s},'.','MarkerSize',20,'MarkerEdgeColor',[0.5,0.5,0.5])
    end
end
  xticks(1:length(BFs{b,s})); xticklabels(modelnames); 
  set(gca,'FontSize',25)
  set(gca,'TickLabelInterpreter','Latex');
   plot(0:length(BFs{b,1})+1,ones(1,length(BFs{b,1})+2),'k','LineWidth',1)
   plot(0:length(BFs{b,1})+1,-ones(1,length(BFs{b,1})+2),'k','LineWidth',1)
   plot(0:length(BFs{b,1})+1,zeros(1,length(BFs{b,1})+2),'k')
     axis([1.5 length(BFs{b,1})+1 -20 10])
     ylabel('Log(Bayes Factor)','Interpreter','Latex')
