rng(1);
X = [CME(100,10);CME(100,100);CME(100,1000);CME(100,10000);CME(100,100000)];
f = figure();
boxplot(X.',{'10','100','1000','10000','100000'})
title('Error in mean versus sample size')
xlabel('Sample Size (Logarithmic Scale)')
ylabel('Mean Error')
saveas(f, "Boxplot of mean errors.png")




function collect_mean_error = CME(num, n) %num = 100%Collates mean errors for 100 samples of size N
    collect_mean_error = zeros(1,num);
    for i=1:num
        collect_mean_error(i) = MLM(n);
    end 
end



function mean_error = MLM(n) %Calculates mean error for a sample of size N
    e = empiricalMean(generateSample(n));
    mean_error = norm(e-[1;2])/norm(e);
end


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