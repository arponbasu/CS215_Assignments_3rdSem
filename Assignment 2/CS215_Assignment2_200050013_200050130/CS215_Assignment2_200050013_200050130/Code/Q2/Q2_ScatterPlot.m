rng(1);
f1 = figure();
pP(10)
saveas(f1, "Scatter_Plot_1.png");
f2 = figure();
pP(100)
saveas(f2, "Scatter_Plot_2.png");
f3 = figure();
pP(1000)
saveas(f3, "Scatter_Plot_3.png");
f4 = figure();
pP(10000)
saveas(f4, "Scatter_Plot_4.png");
f5 = figure();
pP(100000)
saveas(f5, "Scatter_Plot_5.png");






function plotPoints = pP(n) %Plots n points and the direction of their maximum variance
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
    [V,D] = eig(empiricalVariance(g));
    if D(1,1) > D(2,2)
        egv = sqrt(D(1,1));
        d = V(:,1);
    else
        egv = sqrt(D(2,2));
        d = V(:,2);
    end
    m = d(2)/d(1);
    cs = cos(atan(m));
    l1 = linspace(e(1:1,:)-egv*cs,e(1:1,:)+egv*cs,500); % Fix this
    l2 = m*(l1-e(1:1,:)) + e(2:2,:);
    scatter(X,Y,c = 'blue')
    hold on
    plot(e(1:1,:),e(2:2,:),'o',l1,l2,'LineWidth',2)
    hold off
end






 



%All other functions same as previous files


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