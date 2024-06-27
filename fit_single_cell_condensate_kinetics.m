% Note that the Source Data matrices provided on the "Fig S2B" tab can be
% directly used as the variable "y_rap" - the delta_CVs for rapamycin
% treatment in each cell, at each time point.

load S2B_5um_rap

nY = 61; % Number of timepoints in total.
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

% the tau below is obtained from fitted_model.c; I do not know how to get
% the 95% confidence bounds as a variable, so I manually entered these
% values below:
fprintf('tau = %0.3g\n', fitted_model.c)
text(20,1.1,'\tau = 15.4 +/- 2.9 min', 'fontsize', 14) 

% again, number of replicates is manually entered below based on the dates
% we have carried out the experiments.
title(sprintf('n = %d cells from 4 replicates', size(yn_rap,2)))