%% Republic of China CDC data
clear; clc; close all;

opts = detectImportOptions('TCDCIntlEpidAll.csv');
opts.SelectedVariableNames = {'sent', 'headline', 'description'};
data = readtable('TCDCIntlEpidAll.csv', opts);

data_nCoV = {};

for i=height(data):-1:1
    if ismember('中國大陸-新型冠狀病毒肺炎', data.headline{i,1})
        row = data{i,:};
        data_nCoV = [data_nCoV; row];
    end
end

%% LSM prediction
A = [x.^9, x.^8, x.^7, x.^6, x.^5, x.^4, x.^3, x.^2, x, x.^0];
% formula:
Xopt = (A'*A)\(A'*Y);
% Y = AX
x = (1:1:75)';
A = [x.^9, x.^8, x.^7, x.^6, x.^5, x.^4, x.^3, x.^2, x, x.^0];
y_fit = A * Xopt;
% plot
plot(x+737760, y_fit, '-.r', 'LineWidth',1)
datetick('x', 'yyyy-mm-dd')
