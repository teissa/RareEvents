load Data3EF
blocks=5;
blocknames={'CT','HA','HS','EA','ES'};
subjects=size(SubBias,2);

for k=1:5
 figure; hold on;
      plot(SubBias(k,:),SubVariance(k,:),'k.','MarkerSize',20)
     title(blocknames{k},'Interpreter','Latex')
     xlabel('Bias','Interpreter','Latex')
     ylabel('Variance','Interpreter','Latex')
      axis([-10 10 -0.2 1.2])
     set(gca, 'FontSize', 30)
      plot([0 0], [-1 20], 'k:')
      plot([-10 10], [0 0], 'k:')
       set(gca,'TickLabelInterpreter','Latex')
 end
 