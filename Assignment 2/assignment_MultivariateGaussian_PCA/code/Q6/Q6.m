rng(1);
clear;
images = cell(16,1);
image_vectors = cell(16,1);
for i = 1:16
    images{i} = im2double(imread("data_fruit\image_" + num2str(i) + ".png"));
    image_vectors{i} = reshape(images{i},19200,1);
end

MeanVec = zeros(19200,1,"double");
for i = 1:16
    MeanVec = MeanVec + image_vectors{i};
end
MeanVec = MeanVec/16;


cov_mat = zeros(19200,16,"double");
for i = 1:16
    cov_mat(:,i) = image_vectors{i} - MeanVec;
end
cov_mat = cov_mat*(cov_mat.')/16;

[PEV, D] = eigs(cov_mat,10);
PEV = PEV(:,1:4);
PEV = normc(PEV);

f1 = figure();
subplot(1,5,1), imshow(reshape(MeanVec,80,80,3))
subplot(1,5,2), imshow(reshape(rescale(PEV(:,1)),80,80,3))
subplot(1,5,3), imshow(reshape(rescale(PEV(:,2)),80,80,3))
subplot(1,5,4), imshow(reshape(rescale(PEV(:,3)),80,80,3))
subplot(1,5,5), imshow(reshape(rescale(PEV(:,4)),80,80,3))

sgtitle("Mean and Eigenvector Images",'Color','red');
saveas(f1, "Mean and Eigenvector Images.png")


f2 = figure();
plot(diag(D))
title("Eigenvalue plot for the fruits");
xlabel('Eigenvalue Count');
ylabel('Eigenvalue Amplitude');

saveas(f2, "Eigenvector plots.png")

for i = 1:16
    f3 = figure();
    X1 = image_vectors{i};
    X2 = rescale(MeanVec + (((image_vectors{i} - MeanVec).')*PEV*(PEV.')).');
    subplot(1,2,1), imshow(images{i})
    subplot(1,2,2), imshow(reshape(X2,80,80,3))
    error = (norm(X1-X2,'fro')/norm(X1,'fro'))*100;
    str = "Fruit #" + num2str(i) + " and it's Reconstruction";
    sgtitle(str + newline + "The percentage error in it's reconstruction was " + num2str(error) + " %",'Color','red');
    str = str + ".png";
    saveas(f3, str)
end

f4 = figure();
p = randperm(16);
d = diag(D);
d = d(1:4);
subplot(1,3,1), imshow(reshape(rescale(MeanVec + (distort_vector(((image_vectors{p(1)} - MeanVec).')*PEV,d)*(PEV.')).'),80,80,3))
subplot(1,3,2), imshow(reshape(rescale(MeanVec + (distort_vector(((image_vectors{p(2)} - MeanVec).')*PEV,d)*(PEV.')).'),80,80,3))
subplot(1,3,3), imshow(reshape(rescale(MeanVec + (distort_vector(((image_vectors{p(3)} - MeanVec).')*PEV,d)*(PEV.')).'),80,80,3))
sgtitle("3 artificially generated fruit images",'Color','red');
saveas(f4, "Artificially generated fruit images.png")

function d = distort_vector(v,D)
    d = zeros(1,size(v,2)); 
    for i = 1:size(v,2)
        X = randn;
        d(1,i) = X*sqrt(D(i)) + v(1,i);
    end
end




