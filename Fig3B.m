load Data3B
blocknames={'CT','HA','HS','EA','ES'};
subjects=size(SubAcc,2);
blocks=5;

%bootstrapping
for k=1:blocks
    for x=1:10000
        rn=randi(subjects,[1,subjects]);
        rnIO(x,k)=mean(IdealObsRespLow(k,rn));
        rnSub(x,k)=mean(SubRespLow(k,rn));
    end
end
sebootIO=sqrt((mean(rnIO).*(1-mean(rnIO)))./subjects);
ci95bootIO=1.96.*sebootIO;
sebootSub=sqrt((mean(rnSub).*(1-mean(rnSub)))./subjects);
ci95bootSub=1.96.*sebootSub;
 
figure; hold on; 
for k=1:blocks
    plot(repmat(k-0.2,[1,subjects]),IdealObsRespLow(k,:),'d', 'MarkerSize',10,'Color',[0.6 0.6 0.6]); 
    plot(repmat(k+0.2,[1,subjects]),SubRespLow(k,:),'o','MarkerSize',10,'Color',[0.6 0.6 0.6]);
    if k==2 || k==4
         errorbar(k-0.2,mean(rnIO(:,k)),ci95bootIO(k),'d','LineWidth',3,'MarkerSize',15,'MarkerFaceColor','k','Color','k'); 
         errorbar(k+0.2,mean(rnSub(:,k)),ci95bootSub(k),'o','LineWidth',3,'MarkerSize',15,'MarkerFaceColor','k','Color','k'); 
    elseif k==1||k==3||k==5
         errorbar(k-0.2,mean(rnIO(:,k)),ci95bootIO(k),'d','LineWidth',3,'MarkerSize',15,'MarkerEdgeColor','k', 'Color','k'); 
         errorbar(k+0.2,mean(rnSub(:,k)),ci95bootSub(k),'o','LineWidth',3,'MarkerSize',15,'MarkerEdgeColor','k','Color','k'); 
    end
end
plot(0:6,repmat(0.5,[1,7]),'k');
axis([0 6 0 1])
ylabel('Respond Low','Interpreter','Latex');
set(gca,'TickLabelInterpreter','Latex')
set(gca,'FontSize',30)
xticks([1:5]);
xticklabels(blocknames)