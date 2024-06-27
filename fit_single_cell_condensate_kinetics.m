filenames = dir('*.log');

nY = 61; % Number of timepoints in total.

y_rap = nan*ones(nY,length(filenames));
for i = 1:length(filenames)
    tmp = importdata(filenames(i).name);
    y_rap(:,i) = tmp.data(1:nY,4)./tmp.data(1:nY,3);
end

dt = 40/60; % Time between imaging frames in min. Data was typically collected every 40 sec.
x = dt*(-3:(nY-3)-1);

%%
yn_rap = y_rap./y_rap(1,:);
my = mean(yn_rap,2);
sy = std(yn_rap,[],2);
shadedErrorBar(x, my, sy)
xlabel('time (min)')
ylabel('intensity')

%%
my = mean(yn_rap,2);
sy = std(yn_rap,[],2);

model = fittype('a + b*exp(-log(2)/c*x)');
fitopts = fitoptions('method', 'NonlinearLeastSquares', ...
                     'startpoint', [0.4 0.5 2], ...
                     'lower', [0 0 0], ...
                     'upper', [1 1 20]);
fitted_model = fit(x(:), my(:), model, fitopts);

figure(1),clf
shadedErrorBar(x, my, sy)
xlabel('time (min)')
ylabel('intensity')
hold on
plot(x, fitted_model(x), 'k--')
text(20,1.1,'\tau = 15.4 +/- 2.9 min', 'fontsize', 14) % obtained from the fitted_model parameters
fitted_model
title(sprintf('n = %d cells from 4 replicates', size(yn_rap,2)))