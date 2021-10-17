clear;
rng(1);
load('mnist.mat');
dt = im2double(digits_train);
lfg = reshape(dt,784,1,60000);
size(lfg);

labels_train(1);
MeanVec = zeros(784,10);
cnt = double(zeros(1,10));
size(MeanVec(:,2));
size(dt,3);
size(cnt(10));
for i = 1:size(dt,3)
    x = dt(:,:,i);
    y = reshape(x,784,1);
    l = labels_train(i)+1;
    MeanVec(:,l) = MeanVec(:,l) + y;
    cnt(l) = cnt(l) + 1;
end

for i=1:10
   MeanVec(:,i) = MeanVec(:,i)/cnt(i);
end

MeanVec;% This 784x10 array now contains the 10 784x1 mean vectors for the 10 digits


for i=1:60000
    l = labels_train(i)+1;
    lfg(:,:,i) = lfg(:,:,i) - MeanVec(:,l);
end


v = cell(10,1);
for i = 1:10
    v{i} = zeros(784,cnt(i));
end

freeIndex = ones(10,1);


for i = 1:size(lfg,3)
    y = lfg(:,:,i);
    l = 1 + labels_train(i);
    v{l}(:,freeIndex(l)) = y;
    freeIndex(l) = freeIndex(l) + 1;
end




for i = 1:10
    k = size(v{i},2);
    v{i} = v{i}*(v{i}.')/k;
end
v; %This is a 10x1 cell, inside each cell of which is a 784x784 covariance matrix of a digit


principalEigenvectors = zeros(784,10);
principalEigenvalues = zeros(1,10);
modesOfVariation = zeros(1,10);
for i=1:10
    [U,~,~] = svd(v{i});
    principalEigenvectors(:,i) = U(:,1);
    df = eigs(v{i});
    principalEigenvalues(i) = df(1);
    df = eig(v{i});
    m = max(df);
    modesOfVariation(i) = sum(df > 0.01*m); % Keeps only those eigenvalues which are atleast 1% of the maximum 
end


principalEigenvectors; %This contains the "principal mode of variation" (principal eigenvector) of each digit
principalEigenvalues; %This contains the principal eigenvalue (largest eigenvalue) of each digit
modesOfVariation; %This contains the number of most significant eigenvalues of each digit ("large eigenvalues")






for i = 1:10
    f = figure();
    str = "Eigenvalue plot for digit ";
    str = str + num2str(i-1) ;
    plot(eig(v{i}));
    title(str);
    xlabel('Eigenvalue Count');
    ylabel('Eigenvalue Amplitude');
    str = str + ".png";
    saveas(f,str);
end

for i = 1:10
    f = figure();
    m = MeanVec(:,i);
    a = principalEigenvectors(:,i)*sqrt(principalEigenvalues(i));
    subplot(1,3,1), imshow(reshape(m - a,28,28))
    subplot(1,3,2), imshow(reshape(m,28,28))
    subplot(1,3,3), imshow(reshape(m + a,28,28))
    str = "Mean and principal variant images for digit " + num2str(i-1);
    sgtitle(str,'Color','red');
    str = str + ".png";
    saveas(f,str);
end
