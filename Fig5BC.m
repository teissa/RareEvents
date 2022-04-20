load Data5BC

%% Fig 5B
figure; hold on;

for k=[2,4]
    if k==2
        for s=1:length(NoisyBayesianRho{k})
            plot(mean(NoisyBayesianRho{k}{s}),NoisyBayesianBias{k}(s),'.','Color','k','MarkerSize', 20)
            meanNBrhoHA(s)=mean(NoisyBayesianRho{k}{s});
        end
        [rBias,pBias]=corr(meanNBrhoHA',NoisyBayesianBias{k}','Type','Spearman');

        if pBias<0.05 %only consider cases of accentuation
            [p,S]=polyfit(meanNBrhoHA(NoisyBayesianBias{k}>0),NoisyBayesianBias{k}(NoisyBayesianBias{k}>0),1);
            [y,delta]=polyval(p,NoisyBayesianBias{k},S);
            plot(NoisyBayesianBias{k},y,'Color','k','LineWidth',2);
        end
        
        plot([IdealObserverWeight(k) IdealObserverWeight(k)],[0 10],'LineWidth',5,'Color','k')
    elseif k==4
        for s=1:length(NoisyBayesianRho{k})
            plot(mean(NoisyBayesianRho{k}{s}),NoisyBayesianBias{k}(s),'.','Color',[0.6 0.6 0.6],'MarkerSize', 20)
            meanNBrhoEA(s)=mean(NoisyBayesianRho{k}{s});
        end
        [rBias,pBias]=corr(meanNBrhoEA',NoisyBayesianBias{k}','Type','Spearman');

        if pBias<0.05
            [p,S]=polyfit(meanNBrhoEA(NoisyBayesianBias{k}>0),NoisyBayesianBias{k}(NoisyBayesianBias{k}>0),1);
            [y,delta]=polyval(p,NoisyBayesianBias{k},S);
            plot(NoisyBayesianBias{k},y,'Color',[0.6 0.6 0.6],'LineWidth',2);
        end
       plot([IdealObserverWeight(k) IdealObserverWeight(k)],[0 10],'LineWidth',5,'Color',[0.6 0.6 0.6])

    end
end

plot([IdealObserverWeight(1) IdealObserverWeight(1)],[0 10],'LineWidth',5,'Color','r')
axis([0 8 0 10])
ylabel('Bias','Interpreter','Latex')
xlabel('Rare Ball Weight ($\rho$)','Interpreter','Latex')
set(gca,'FontSize',30)

%% Fig 5C

figure; hold on;

for k=[2,4]
    if k==2
        for s=1:length(PriorBayesianPrior{k})
            plot(mean(PriorBayesianPrior{k}{s}),PriorBayesianBias{k}(s),'.','Color','k','MarkerSize', 20)
            meanPBpriorHA(s)=mean(PriorBayesianPrior{k}{s});
        end
        [rBias,pBias]=corr(meanPBpriorHA',PriorBayesianBias{k}','Type','Spearman');

        if pBias<0.05
            [p,S]=polyfit(meanPBpriorHA,PriorBayesianBias{k},1);
            [y,delta]=polyval(p,PriorBayesianBias{k},S);
            plot(PriorBayesianBias{k},y,'Color','k','LineWidth',2);
        end
        
    elseif k==4
        for s=1:length(PriorBayesianPrior{k})
            plot(mean(PriorBayesianPrior{k}{s}),PriorBayesianBias{k}(s),'.','Color',[0.6 0.6 0.6],'MarkerSize', 20)
            meanPBpriorEA(s)=mean(PriorBayesianPrior{k}{s});
        end
        [rBias,pBias]=corr(meanPBpriorEA',PriorBayesianBias{k}','Type','Spearman');

        if pBias<0.05
            [p,S]=polyfit(meanPBpriorEA,PriorBayesianBias{k},1);
            [y,delta]=polyval(p,PriorBayesianBias{k},S);
            plot(PriorBayesianBias{k},y,'Color',[0.6 0.6 0.6],'LineWidth',2);
        end
    end
end

plot([-1 1],[0 0],'LineWidth',1,'Color','k')
plot([0 0],[-10 10],'LineWidth',1,'Color','k')
axis([-1 1 -10 10])
ylabel('Bias','Interpreter','Latex')
xlabel('Prior','Interpreter','Latex')
set(gca,'FontSize',30)