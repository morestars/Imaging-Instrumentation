load('colors.mat')
img0 = reshape(img0, 1, []);
img1 = reshape(img1, 1, []);
img2 = reshape(img2, 1, []);
img3 = reshape(img3, 1, []);
img4 = reshape(img4, 1, []);
img5 = reshape(img5, 1, []);
img6 = reshape(img6, 1, []);
X = cat(1,img0,img1,img2,img3,img4,img5,img6);
[U,S,V] = svd(X,'econ');
pca =V*X;
plot(pca(:,1),pca(:,2),'*')%plot for two principal components
title('The two principal components PCA')
xlabel('First component')
ylabel('Second component ')
%% 
k = 3; %RGB
[idx,C,sumd,D] = kmeans(pca,k,'MaxIter',10000);
D1 = reshape(D,[],1,3);
ColorImg = Reshape(D1,1280,1024,3);
im(ColorImg);
