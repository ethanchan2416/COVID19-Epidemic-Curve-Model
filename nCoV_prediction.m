%% Plot WHO Official Data (Global Confirmed Accumulated Cases)
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

stem(datenum, infected, 'o', 'LineWidth',1)
grid on; hold on;
stem(datenum, death, 'xr', 'LineWidth',1)
set(gcf, 'Position',  [500, 300, 900, 500])
datetick('x', 'yyyy-mm-dd')

%% automatic LSM
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
A = [];

order = 8;

for i=0:order
    A = [A, x.^i];
    Xopt = (A'*A)\(A'*Y);
    y_fit = A * Xopt;
    rNorm(i+1,1) = sum(abs(Y - y_fit))/length(Y);
    % plot
%     stem(datenum, infected, 'o', 'LineWidth',1) %... plot WHO data
%     hold on; grid on;
%     set(gcf, 'Position',  [500, 300, 900, 500])
%     plot(x+737760, y_fit, '-.r', 'LineWidth',1) %... plot prediction curve
%     datetick('x', 'yyyy-mm-dd')
%     hold off;
%     pause(0.5);
end

%% Predict Tomorrow Confirmed Case
x = iDay(end) + 1;

A_pred = [];
for i=0:order
    A_pred = [A_pred, x.^i];
end
pred_cases_tomorrow = A_pred * Xopt

%%
x = (1:1:100)';

A_pred = [];
for i=0:order
    A_pred = [A_pred, x.^i];
end
y_pred = A_pred * Xopt;
[peak_cases, peak_iDay] = max(y_pred);
peak_cases
peak_date = datetime(737760+peak_iDay,'ConvertFrom','datenum')
% plot
% figure
% plot(x+737760, y_pred, '-.r', 'LineWidth',1)
% datetick('x', 'yyyy-mm-dd')
% set(gcf, 'Position',  [500, 300, 900, 500])

%% plot rNorm
figure
plot(0:1:order, rNorm)
