clear;
rng(1);

v = {5,10,20,40,60,80,100,500,1000,10000};
n = size(v,2);
ML_errors = zeros(n,100,'double');
PM_errors = zeros(n,100,'double');
for i = 1:n
    [x,y] = error_arr(v{i});
    ML_errors(i,:) = x;
    PM_errors(i,:) = y;
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
boxplot(PM_errors.',v_str)
title('Error in Bayesian Estimate versus sample size')
xlabel('Sample Size')
ylabel('Error in Bayesian Estimate')
saveas(f, "Boxplot of Bayesian Estimate errors.png")


function [eaML, eaPM] = error_arr (N)
    eaML = zeros(100,1,'double');
    eaPM = zeros(100,1,'double');
    for i = 1:100
        d = dataset(N);
        eaML(i) = 0.2*abs(lambda_ML(d) - 5);
        eaPM(i) = 0.2*abs(lambda_PosteriorMean(d,5.5,1) - 5);
    end
    eaML = eaML.';
    eaPM = eaPM.';
end

function lpm = lambda_PosteriorMean(dat, alpha, beta)
    n = size(dat,1);
    lpm = (n + alpha)/(beta + sum(dat));
end

function lml = lambda_ML(dat)
    n = size(dat,1);
    lml = n/sum(dat);
end

function Y = dataset(N)
    X = rand(N,1);
    Y = -0.2*log(X);
end