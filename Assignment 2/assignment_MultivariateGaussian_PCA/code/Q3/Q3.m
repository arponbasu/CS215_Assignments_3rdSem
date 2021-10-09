
load('points2D_Set1.mat')
z = horzcat(x,y);
    n = size(z,1);
    a1 = ones(n)*z/n;
    x0 = a1(1,1);
    y0 = a1(1,2);
    a = z - a1;
    K = (a.')*a/n;
    [U,S,V] = svd(K);
    d = U(:,1);
    m = d(2)/d(1);
    l1 = linspace(min(x)-0.2,max(x)+0.2,500);
    l2 = m*(l1-x0) + y0;
    plot(x0,y0,'o',l1,l2)
    hold on
    scatter(x,y,c = 'blue')
    hold off
    
load('points2D_Set2.mat')
z = horzcat(x,y);
    n = size(z,1);
    a1 = ones(n)*z/n;
    x0 = a1(1,1);
    y0 = a1(1,2);
    a = z - a1;
    K = (a.')*a/n;
    [U,S,V] = svd(K);
    d = U(:,1);
    m = d(2)/d(1);
    l1 = linspace(min(x)-0.2,max(x)+0.2,500);
    l2 = m*(l1-x0) + y0;
    plot(x0,y0,'o',l1,l2)
    hold on
    scatter(x,y,c = 'blue')
    hold off
    