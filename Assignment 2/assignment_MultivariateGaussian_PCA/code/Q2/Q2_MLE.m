rng(1);
D = generateSample(10);
"The MLEs of mean and covariance matrices for sample size 10 is" 
empiricalMean(D)
empiricalVariance(D)
D = generateSample(100);
"The MLEs of mean and covariance matrices for sample size 100 is" 
empiricalMean(D)
empiricalVariance(D)
D = generateSample(1000);
"The MLEs of mean and covariance matrices for sample size 1000 is" 
empiricalMean(D)
empiricalVariance(D)
D = generateSample(10000);
"The MLEs of mean and covariance matrices for sample size 10000 is" 
empiricalMean(D)
empiricalVariance(D)
D = generateSample(100000);
"The MLEs of mean and covariance matrices for sample size 100000 is" 
empiricalMean(D)
empiricalVariance(D)




function V_hat = empiricalVariance(C) %MLE for covariance matrix
    V_hat = zeros(2,2);
    sz = size(C,2);
    mu_hat = empiricalMean(C);
    for i=1:sz
        K = (C{i} - mu_hat);
        V_hat = V_hat + K*(K.');
    end
    V_hat = V_hat/sz;
end

function mu_hat = empiricalMean(C) %MLE for mean vector
    mu_hat = zeros(2,1);
    sz = size(C,2);
    for i=1:sz
        mu_hat = mu_hat + C{i};
    end
    mu_hat = mu_hat/sz;
end

function C = generateSample(n) %Generates n samples of our Gaussian
    Sigma = [1.6250 -1.9486; -1.9486 3.8750];
    mu = [1;2];
    A = spectralDecomposition(Sigma);
    for i=1:n
        C{i} = A*randn([2,1])+mu;
    end 
end

function Y = spectralDecomposition(X) %X = YY^T
    [V,D] = eig(X);
    sqD = [sqrt(D(1,1)) 0;0 sqrt(D(2,2))];
    Y = V*sqD;
end