rng(1);

Y = [CVE(100,10);CVE(100,100);CVE(100,1000);CVE(100,10000);CVE(100,100000)];
f = figure();
boxplot(Y.',{'10','100','1000','10000','100000'})
title('Error in covariance matrix versus sample size')
xlabel('Sample Size (Logarithmic Scale)')
ylabel('Covariance Matrix Error')
saveas(f, "Boxplot of variance errors.png")




function collect_var_error = CVE(num, n) %num = 100%Collates covariance errors for 100 samples of size N
    collect_var_error = zeros(1,num);
    for i=1:num
        collect_var_error(i) = VLM(n);
    end 
end



function var_error = VLM(n) %Calculates Frobenius error for covariance matrix
    e = empiricalVariance(generateSample(n));
    var_error = norm(e-[1.6250 -1.9486; -1.9486 3.8750],'fro')/norm(e,"fro");
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