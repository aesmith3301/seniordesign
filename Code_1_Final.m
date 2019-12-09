%%
clear all; close all; clc;

data = csvread('data.csv',1,1);
yvalues_s = data(1,1:178);
xvalues_s = 1:1:178;

figure
plot(xvalues_s,yvalues_s)
title('EEG Graph of a Seizure Event')
xlabel('Time Axis')
ylabel('Signal Intensity')

yvalues_h = data(5630,1:178);
xvalues_h = 1:1:178;

figure
plot(xvalues_h,yvalues_h)
title('EEG Graph of a Healthy Brain')
xlabel('Time Axis')
ylabel('Signal Intensity')

%%

s_data = csvread('seizure.csv');
s_data(:,179) = [];
s_data_prefft = s_data';
fft_s_data = fft(s_data_prefft);
fft_s_data = fft_s_data';

plot(xvalues_s,fft_s_data(4,:))
title('Fourier Transform of EEG Data for Seizure Events')
xlabel('Frequency Domain')

h_data = csvread('Healty.csv');
h_data (:,179) = [];
h_data_prefft = h_data';
fft_h_data = fft(h_data_prefft);
fft_h_data = fft_h_data';

figure
plot(xvalues_s,fft_h_data(4,:))

max_fft_h = max(abs(fft_h_data'))';
max_fft_s = max(abs(fft_s_data'))';


range_h = abs(max(h_data')-min(s_data'));
range_s = abs(max(s_data')-min(s_data'));
range_h = range_h';
range_s = range_s';

max_h = max(abs(h_data'));
max_s = max(abs(s_data'));
max_h = max_h';
max_s = max_s';

pca_data(:,2) = max_h;
pca_data(:,3) = range_h;
pca_data(:,4) = max_fft_h;
pca_data(1:2300,1) = 0;

pca_data(2301:4600,2) = max_s;
pca_data(2301:4600,3) = range_s;
pca_data(2301:4600,4) = max_fft_h;
pca_data(2301:4600,1) = 1;

%% PCA
[coeff,score,latent] = pca(pca_data(:,2:4));

%% LDA

for n = 1:length(pca_data)
    TrainData = pca_data(:,[2,3,4]);
    TrainData(n,:) = [];
    TrainTruth = pca_data(:,1);
    TrainTruth(n,:) = [];
    
    TestData = pca_data(n,[2,3,4]);
    [class(n),err,posterior] = classify(TestData,TrainData,TrainTruth,'linear');
    
    dv(n) = TestData(:,1)*posterior(:,1)+TestData(:,2)*posterior(:,2);
end

dv = dv';
ROC(:,1) = pca_data(:,1);
ROC(:,2) = dv;

figure
[AUC] = myROC(ROC);
title('LDA ROC Curve')

%% ROC

ROC_test1(:,1) = pca_data(:,1);
ROC_test2(:,1) = pca_data(:,1);
ROC_test3(:,1) = pca_data(:,1);
ROC_test1(:,2) = pca_data(:,2);
ROC_test2(:,2) = pca_data(:,3);
ROC_test3(:,2) = pca_data(:,4);

figure
[AUC_PC1] = myROC(ROC_test1);
title('ROC Curve for Max Deviation')

figure
[AUC_PC2] = myROC(ROC_test2);
title('ROC Curve for Singal Intensity Range')

figure
[AUC_PC3] = myROC(ROC_test3);
title('ROC Curve for Fourier Transform Max')

