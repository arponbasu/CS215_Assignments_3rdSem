clear;
rng(1);
std_dev = 4;
mean_val= 10;
v = {5,10,20,40,60,80,100,500,1000,10000};
n = size(v,2);
ML_errors = zeros(n,100,'double');
PM_errors_1 = zeros(n,100,'double');
PM_errors_2 = zeros(n,100,'double');

for i = 1:n
    [x,y,z] = error_arr(v{i}, mean_val, std_dev);
    ML_errors(i,:) = x;
    PM_errors_1(i,:) = y;
    PM_errors_2(i,:) = z;
end

v_str = cell(1,n);
for i = 1:n
    v_str{i} = num2str(v{i});
end

f = figure();
boxplot(ML_errors.',v_str)
title('Error in ML Estimate versus sample size')
xlabel('Sample Size')
ylabel('Error in ML Estimate')
saveas(f, "Boxplot of ML Estimate errors.png")


f = figure();
boxplot(PM_errors_1.',v_str)
title('Error in Bayesian Estimate versus sample size- Prior1')
xlabel('Sample Size')
ylabel('Error in Bayesian Estimate')
saveas(f, "Boxplot of Bayesian Estimate errors- Prior1.png")

f = figure();
boxplot(PM_errors_2.',v_str)
title('Error in Bayesian Estimate versus sample size- Prior2')
xlabel('Sample Size')
ylabel('Error in Bayesian Estimate')
saveas(f, "Boxplot of Bayesian Estimate errors- Prior2.png")

function [eaML, eaPM_1, eaPM_2] = error_arr (N, mean_val, std_dev)
    eaML = zeros(100,1,'double');
    eaPM_1 = zeros(100,1,'double');
    eaPM_2 = zeros(100,1,'double');
    for i = 1:100
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
    lpm = (sample_mean*prior_stddev*prior_stddev+prior_mean*std_dev*std_dev)/(std_dev*std_dev+prior_stddev*prior_stddev);
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