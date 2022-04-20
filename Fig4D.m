load Data4D
blocks=5;
models=6;
modelnames={'noisy', 'set $\rho$','Prior','Var','Rare','Guess'};

edges=1:7;
for k=1:blocks
    h2(k,:)=histcounts(BestModel(k,:),edges); 
end

figure; bb=bar(h2,'stacked');
for kk=1:models
    bb(kk).FaceColor=clrs(kk,:);
end
legend(modelnames,'Interpreter','Latex')
 xticks(1:5); xticklabels({'CT','HA','HS','EA','ES'});
 set(gca,'FontSize',30)
 set(gca,'TickLabelInterpreter','Latex');
 ylim([0 205])