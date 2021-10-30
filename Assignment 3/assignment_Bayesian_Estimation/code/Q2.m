clear;
rng(1);

v = {5,10,20,40,60,80,100,500,1000,10000};
n = size(v,2);
samples = 200;

ML_errors = zeros(n,samples,'double');
PM_errors = zeros(n,samples,'double');
for i = 1:n
    [x,y] = error_arr(v{i}, samples);
    ML_errors(i,:) = x;
    PM_errors(i,:) = y;
end

v_str = cell(1,n);
for i = 1:n
    v_str{i} = num2str(v{i});
end
position_1 = zeros(n, 1, 'double');
position_2 = zeros(n, 1, 'double');
for i = 1:n
    position_1(i) = 4*i;
    position_2(i) = 4*i+2;
end
f = figure();
b1 = boxplot(ML_errors.','positions', position_1,'labels', v_str, 'boxstyle', 'filled', 'color', 'r');

title('Error comparison of ML Estimate and Bayesian Estimate versus sample size')
xlabel('Sample Size')
ylabel('Error')
hold on
b2 = boxplot(PM_errors.','positions', position_2,'labels', v_str, 'boxstyle', 'filled', 'color', 'b');
hLegend = legend([b1(1), b2(1)], {'MLE','Bayesian'});
saveas(f, "Q2.png")


function [eaML, eaPM] = error_arr (N,samples)
    eaML = zeros(samples,1,'double');
    eaPM = zeros(samples,1,'double');
    for i = 1:samples
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