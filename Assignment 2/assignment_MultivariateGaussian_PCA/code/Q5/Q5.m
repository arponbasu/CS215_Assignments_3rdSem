clear all;
load('mnist.mat');
dt = im2double(digits_train);
digit = reshape(dt,784,1,60000);

MeanVec = zeros(784,10);
cnt = double(zeros(1,10));

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
    digit(:,:,i) = digit(:,:,i) - MeanVec(:,l);
end


v = cell(10,1);
for i = 1:10
    v{i} = zeros(784,cnt(i));
end

freeIndex = ones(10,1);


for i = 1:size(digit,3)
    y = digit(:,:,i);
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
    principalEigenvectors(:,1:84, i) = U(:,1:84);
    df = eig(v{i});
    df = sort(df, 'descend');
    principalEigenvalues(1:84, i) = df(1:84);
%     m = max(df);
%     modesOfVariation(i) = sum(df > 0.01*m); % Keeps only those eigenvalues which are atleast 1% of the maximum 
end


z = principalEigenvectors; %This contains the "principal mode of variation" (principal eigenvector) of each digit
principalEigenvalues; %This contains the principal eigenvalue (largest eigenvalue) of each digit
modesOfVariation; %This contains the number of most significant eigenvalues of each digit ("large eigenvalues")





