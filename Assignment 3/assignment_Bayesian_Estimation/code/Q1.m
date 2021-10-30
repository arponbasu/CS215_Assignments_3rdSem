clear all;
rng(1);
std_dev = 4;
mean_val= 10;
v = {5,10,20,40,60,80,100,500,1000,10000};
n = size(v,2);
samples = 200;
ML_errors = zeros(n,samples,'double');
PM_errors_1 = zeros(n,samples,'double');
PM_errors_2 = zeros(n,samples,'double');

for i = 1:n
    [x,y,z] = error_arr(v{i}, mean_val, std_dev, samples);
    ML_errors(i,:) = x;
    PM_errors_1(i,:) = y;
    PM_errors_2(i,:) = z;
end

v_str = cell(1,n);
for i = 1:n
    v_str{i} = num2str(v{i});
end
position_1 = zeros(n, 1, 'double');
position_2 = zeros(n, 1, 'double');
position_3 = zeros(n, 1, 'double');
for i = 1:n
    position_1(i) = 6*i;
    position_2(i) = 6*i+2;
    position_3(i) = 6*i+4;
end
f = figure();
b1= boxplot(ML_errors.','positions', position_1,'labels', v_str, 'boxstyle', 'filled', 'color', 'r');
title('Error in different Estimates versus sample size')
xlabel('Sample Size')
ylabel('Error in ML Estimate')

hold on
b3= boxplot(PM_errors_2.','positions', position_3,'labels', v_str, 'boxstyle', 'filled', 'color', 'b');
hold on

b2= boxplot(PM_errors_1.','positions', position_2,'labels', v_str, 'boxstyle', 'filled', 'color', 'g');


hLegend = legend([b1(1), b2(1), b3(1)], {'MLE','Bayesian with Gaussian Prior', 'Bayesian with Uniform Prior'});

saveas(f, "Q1.png")

function [eaML, eaPM_1, eaPM_2] = error_arr (N, mean_val, std_dev, samples)
    eaML = zeros(samples,1,'double');
    eaPM_1 = zeros(samples,1,'double');
    eaPM_2 = zeros(samples,1,'double');
    for i = 1:samples
        d = dataset(N, mean_val, std_dev);
        eaML(i) = abs(lambda_ML(d) - mean_val)/mean_val;
        eaPM_1(i) = abs(lambda_PosteriorMean_1(d,10.5, 1, std_dev) - mean_val)/mean_val;
        eaPM_2(i) = abs(lambda_PosteriorMean_2(d,9.5, 11.5) - mean_val)/mean_val;        
    end
    eaML = eaML.';
    eaPM_1 = eaPM_1.';
    eaPM_2 = eaPM_2.';
end

function lpm = lambda_PosteriorMean_1(dat, prior_mean, prior_stddev, std_dev)
    n = size(dat,1);
    sample_mean = sum(dat)/n;
    lpm = (sample_mean*prior_stddev*prior_stddev+prior_mean*std_dev*std_dev/n)/(std_dev*std_dev/n+prior_stddev*prior_stddev);
end

function lpm = lambda_PosteriorMean_2(dat, left, right)
    n = size(dat,1);
    sample_mean = sum(dat)/n;
    if(sample_mean<left)
        sample_mean = left;
    elseif(sample_mean>right)
        sample_mean = right;
    end
    lpm = sample_mean;
end

function lml = lambda_ML(dat)
    n = size(dat,1);
    lml = sum(dat)/n;
    %to be added
end

function X = dataset(N, mean_val, std_dev)
    
    X = std_dev*randn(N,1)+mean_val;
end