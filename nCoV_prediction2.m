%% WHO Official Data (Global Confirmed Accumulated Cases)
clear; clc; close all;

data = xlsread('ncov_data.xlsx');
adjust_datenum = 693960;
data(:,1) = data(:,1) + adjust_datenum;
datenum = data(:,1);
infected = data(:,2);
death = data(:,3);

for i=1:length(data)
    iDay(i) = datenum(i) - datenum(1) + 1;
end
x = iDay';
Y = infected;

%% Get New Case Xopt
new_iDay = datenum(22:end) - 737760;
new_infected = data(22:end,8);

order = 8;
[y_fit, Xopt, rNorm] = fit(new_iDay, new_infected, order);
plot(new_iDay+737760, y_fit)
hold on; grid on;
plot(new_iDay+737760, new_infected)
title('New Confirmed Global Cases Per Day', 'FontSize',20)
legend('Projected Curve', 'Official Data', 'FontSize',16)
datetick('x', 'yyyy-mm-dd')
figure
plot(0:1:order, rNorm)

%% Predict New Case Curve
x = (new_iDay(1):1:100)';
A_pred = [];
for i=0:order
    A_pred = [A_pred, x.^i];
end
y_pred = A_pred * Xopt;
% figure
plot(x+737760, y_pred, '-.r', 'LineWidth',1)
datetick('x', 'yyyy-mm-dd')
yline(0)
%%
[y_fit, rNorm] = fit(x, Y, 8);
figure
plot(x+737760, y_fit, '-.r', 'LineWidth',1)
datetick('x', 'yyyy-mm-dd')
set(gcf, 'Position',  [500, 300, 900, 500])


%%
function [y_fit, Xopt, rNorm] = fit(x, Y, order)
    A = [];
    for i=0:order
        A = [A, x.^i];
        Xopt = (A'*A)\(A'*Y);
        y_fit = A * Xopt;
        rNorm(i+1,1) = sum(abs(Y - y_fit))/length(Y);
    end
end