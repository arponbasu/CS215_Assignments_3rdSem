A = spectralDecomposition([1.6250 -1.9486; -1.9486 3.8750]);
mu = [1;2];
%Prop = A*(A.')
%randn([2,1])
C = generateSample(100000);
%C{1}
%empiricalMean(C)
%empiricalVariance(C)
%MLM(1000)
%vfbb = CME(100,1000);
%vfbb(:,55);

%X = [CME(100,10);CME(100,100);CME(100,1000);CME(100,10000);CME(100,100000)];

boxplot(X.',{'10','100','1000','10000','100000'})
%title('Error in mean versus sample size')
%xlabel('Sample Size (Logarithmic Scale)')
%ylabel('Mean Error')

Y = [CVE(100,10);CVE(100,100);CVE(100,1000);CVE(100,10000);CVE(100,100000)];

boxplot(Y.',{'10','100','1000','10000','100000'})
title('Error in covariance matrix versus sample size')
xlabel('Sample Size (Logarithmic Scale)')
ylabel('Covariance Matrix Error')

pP(1000)

function plotPoints = pP(n)
    C = generateSample(n);
    sz = size(C,2);
    X = zeros(1,sz);
    Y = zeros(1,sz);
    for i=1:sz
        d = C{i};
        X(i) = d(1:1,:);
        Y(i) = d(2:2,:);
    end
    g = generateSample(n);
    e = empiricalMean(g);
    [U,S,V] = svd(empiricalVariance(g));
    d = U(:,1);
    m = d(2)/d(1);
    l1 = linspace(min(X)-0.2,max(X)+0.2,500); % Fix this
    l2 = m*(l1-e(1:1,:)) + e(2:2,:);
    plot(e(1:1,:),e(2:2,:),'o',l1,l2)
    hold on
    scatter(X,Y,c = 'blue')
    
end



function collect_var_error = CVE(num, n) %num = 100
    collect_var_error = zeros(1,num);
    for i=1:num
        collect_var_error(i) = VLM(n);
    end 
end



function var_error = VLM(n)
    e = empiricalVariance(generateSample(n));
    var_error = norm(e-[1.6250 -1.9486; -1.9486 3.8750],'fro')/norm(e,"fro");
end


function collect_mean_error = CME(num, n) %num = 100
    collect_mean_error = zeros(1,num);
    for i=1:num
        collect_mean_error(i) = MLM(n);
    end 
end



function mean_error = MLM(n)
    e = empiricalMean(generateSample(n));
    mean_error = norm(e-[1;2])/norm(e);
end


function V_hat = empiricalVariance(C)
    V_hat = zeros(2,2);
    sz = size(C,2);
    mu_hat = empiricalMean(C);
    for i=1:sz
        K = (C{i} - mu_hat);
        V_hat = V_hat + K*(K.');
    end
    V_hat = V_hat/sz;
end

function mu_hat = empiricalMean(C)
    mu_hat = zeros(2,1);
    sz = size(C,2);
    for i=1:sz
        mu_hat = mu_hat + C{i};
    end
    mu_hat = mu_hat/sz;
end

function C = generateSample(n)
    Sigma = [1.6250 -1.9486; -1.9486 3.8750];
    mu = [1;2];
    A = spectralDecomposition(Sigma);
    for i=1:n
        C{i} = A*randn([2,1])+mu;
    end 
end

function Y = spectralDecomposition(X)
    [V,D] = eig(X);
    sqD = [sqrt(D(1,1)) 0;0 sqrt(D(2,2))];
    Y = V*sqD;
end