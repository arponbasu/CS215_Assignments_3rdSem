clear;
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

transform = cell(10,1);
coord = cell(10,1);
for i = 1:10
    [U,~,~] = svd(v{i});
    V = normc(U(:,1:84));
    coord{i} = V;
    W = V*(V.');
    transform{i} = W;
end


for i = 1:10
    f1 = figure();
    it = giveIndexOfDigit(i-1, labels_train);
    str = "Digit " + num2str(i-1) + " and it's reconstruction";
    subplot(1,2,1), imshow(dt(:,:,it))
    subplot(1,2,2), imshow(reshape(reshape(dt(:,:,it),1,784)*transform{labels_train(it)+1},28,28))
    sgtitle(str,'Color','red');
    str = str + ".png";
    saveas(f1,str);
end



function cc = calculateCoordinates(X, lab, coord) %X is a 28x28 pixel image, lab is it's label
    t = reshape(X,1,784);
    cc = t*coord{lab+1};
end

function reconstructImage(X, lab, transform) %X is a 28x28 pixel image, lab is it's label
    subplot(1,2,1), imshow(X)
    subplot(1,2,2), imshow(reshape(reshape(X,1,784)*transform{lab+1},28,28))
end

function iter = giveIndexOfDigit(i, labels_train)
    iter = 1;
    while labels_train(iter) ~= i
        iter = iter + 1;
    end
end

