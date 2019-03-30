%% Lab 5
%{
1 bit has an intensity of different photon wavelengths
RGB cones in the eye are sensitive to different wavelengths
less sensitive to short wavelengths and more sensitive to high wavelengths
rods - mostly active in the dark
in the dark, start to see green due to our own sensitivities
as long as the signal integrates the same, you see the same color
    monomores
base functions -> number of cones, tightness of curve
red filter lets red light pass
photon efficiency of detector
lens can be selective for different wavelengths
    coatings may restrict some photons

img0 - no filter            F(7,:)
img1 - 400 nm (violet)      F(6,:)
img2 - 450 nm (blue)        F(5,:)
img3 - 500 nm (blue-green)  F(4,:)
img4 - 550 nm (green)       F(3,:)
img5 - 600 nm (orange)      F(2,:)
img6 - 650 nm (red)         F(1,:)

Violet 	380–450 nm 	680–790 THz 	2.95–3.10 eV
Blue 	450–485 nm 	620–680 THz 	2.64–2.75 eV
Cyan 	485–500 nm 	600–620 THz 	2.48–2.52 eV
Green 	500–565 nm 	530–600 THz 	2.25–2.34 eV
Yellow 	565–590 nm 	510–530 THz 	2.10–2.17 eV
Orange 	590–625 nm 	480–510 THz 	2.00–2.10 eV
Red 	625–740 nm 	405–480 THz 	1.65–2.00 eV 
%}

%% Camera setup
c = Camera(0);
c.pixelclock = 7;
c.frameraterange = [0.5, 1];
c.exposure = 16; % for both nontransmissive and transmissive scenes
% c.exposure = 1; % for no filter nontransmissive
% c.exposure = 0.9 % for no filter transmissive bean and bee
% aperature = 2.8 on day 1,  2.6 on day 2
% focus = f0.4

%% Acquisition

depth = 200;
imgStack = zeros(1280,1024,depth);
img = zeros(1280,1024);
for i = 1:depth
    imgStack(:,:,i) = c.capture();
end
img = mean(imgStack,3);
maxPix = max(img,[],'all')

%% Raw Data Figures

%load('colors.mat');

%load('bean.mat');
% % % reshape for bean % % %
% img0 = img0(60:180,500:620);
% img1 = img1(60:180,500:620);
% img2 = img2(60:180,500:620);
% img3 = img3(60:180,500:620);
% img4 = img4(60:180,500:620);
% img5 = img5(60:180,500:620);
% img6 = img6(60:180,500:620);

load('bee.mat');
% % % reshape for bee % % %
img0 = img0(90:250,450:650);
img1 = img1(90:250,450:650);
img2 = img2(90:250,450:650);
img3 = img3(90:250,450:650);
img4 = img4(90:250,450:650);
img5 = img5(90:250,450:650);
img6 = img6(90:250,450:650);

img0 = imrotate(flip(img0),270);
img1 = imrotate(flip(img1),270);
img2 = imrotate(flip(img2),270);
img3 = imrotate(flip(img3),270);
img4 = imrotate(flip(img4),270);
img5 = imrotate(flip(img5),270);
img6 = imrotate(flip(img6),270);

figure()
subplot(3,3,2)
im(img0), colormap(gray), colorbar
title('A: No Filter')
xlabel('Position (Pixels)')
ylabel('Position (Pixels)')
subplot(3,3,4)
im(img1), colormap(gray), colorbar
title('B: 400 nm')
xlabel('Position (Pixels)')
ylabel('Position (Pixels)')
subplot(3,3,5)
im(img2), colormap(gray), colorbar
title('C: 450 nm')
xlabel('Position (Pixels)')
ylabel('Position (Pixels)')
subplot(3,3,6)
im(img3), colormap(gray), colorbar
title('D: 500 nm')
xlabel('Position (Pixels)')
ylabel('Position (Pixels)')
subplot(3,3,7)
im(img4), colormap(gray), colorbar
title('E: 550 nm')
xlabel('Position (Pixels)')
ylabel('Position (Pixels)')
subplot(3,3,8)
im(img5), colormap(gray), colorbar
title('F: 600 nm')
xlabel('Position (Pixels)')
ylabel('Position (Pixels)')
subplot(3,3,9)
im(img6), colormap(gray), colorbar
title('G: 650 nm')
xlabel('Position (Pixels)')
ylabel('Position (Pixels)')


%% The Function
load('transfer_functions.mat')
load('colors.mat')

%{
(LT L+D{e}) -1 LT D{1./(b.*l.*s+e)} FT (FFT +D{e}) -1 ? A
%}

de = 1e-5*ones(1,351);
De = diag(de);
De = 5;
Dbse = diag(1./(db2.*dl.*ds+de));
F = F([1 3 5],:);

A = (L'*L+De)^(-1) * L' * Dbse * F' * (F*F'+De)^(-1);

img0 = reshape(img0, 1, []);
img1 = reshape(img0, 1, []);
img2 = reshape(img0, 1, []);
img3 = reshape(img0, 1, []);
img4 = reshape(img0, 1, []);
img5 = reshape(img0, 1, []);
img6 = reshape(img0, 1, []);

%y = cat(1, img6, img5, img4, img3, img2, img1, img0);
y = cat(1, img6, img4, img2);
z = A*y;
xout1 = db2*L*z;

z1 = reshape(z,1280,1024,3);
RGB = db2*L;
for i = 1:3
    z1(:,:,i) = z1(:,:,i)*RGB(i);
end

xout1 = z1;
xout1 = (xout1+min(xout1,[],'all'))/(max(xout1,[],'all')*0.9);

test = reshape(z,1280,1024,3);

%% SVD

load('colors.mat')
%img0 = reshape(img0, 1, []);
img1 = reshape(img1, 1, []);
img2 = reshape(img2, 1, []);
img3 = reshape(img3, 1, []);
img4 = reshape(img4, 1, []);
img5 = reshape(img5, 1, []);
img6 = reshape(img6, 1, []);
%X = cat(1,img0,img1,img2,img3,img4,img5,img6); % w/ img0
X = cat(1,img1,img2,img3,img4,img5,img6); % w/o img0
[U,S,V] = svd(X,'econ');
pca =V*X;
plot(pca(:,1),pca(:,2),'*')%plot for two principal components
title('The two principal components PCA')
xlabel('First component')
ylabel('Second component')

%% SVD continued
k = 3; %RGB
[idx,C,sumd,D] = kmeans(pca,k,'MaxIter',10000);
D1 = reshape(D,[],1,3);
ColorImg = Reshape(D1,1280,1024,3);
im(ColorImg);

%% K-means
load('colors.mat')

%load('bee.mat')
% reshape for bee
%{ 
img0 = img0(90:250,450:650);
img1 = img1(90:250,450:650);
img2 = img2(90:250,450:650);
img3 = img3(90:250,450:650);
img4 = img4(90:250,450:650);
img5 = img5(90:250,450:650);
img6 = img6(90:250,450:650);
%}

%load('bean.mat')
% reshape for bean
%{
img0 = img0(60:180,500:620);
img1 = img1(60:180,500:620);
img2 = img2(60:180,500:620);
img3 = img3(60:180,500:620);
img4 = img4(60:180,500:620);
img5 = img5(60:180,500:620);
img6 = img6(60:180,500:620);
%}

img0 = reshape(img0, 1, []);
img1 = reshape(img1, 1, []);
img2 = reshape(img2, 1, []);
img3 = reshape(img3, 1, []);
img4 = reshape(img4, 1, []);
img5 = reshape(img5, 1, []);
img6 = reshape(img6, 1, []);

imgVector = [img1' img2' img3' img4' img5' img6'];
%imgVector = [img2' img4' img6'];
%imgVector = log10(imgVector);

k = 50;
kMeansIdx = kmeans(imgVector,k,'MaxIter',10000);

kMeansImg = reshape(kMeansIdx,1280,1024); % shrink-wrap
%kMeansImg = reshape(kMeansIdx,161,201); % bee
%kMeansImg = reshape(kMeansIdx,121,121); % bean

cmap = linspace(0,1,k)';
cmap = cmap.*ones(k,3);
cmap = flipud(cmap);

kMeansImg = flip(kMeansImg);
kMeansImg = imrotate(kMeansImg,270);

% cmap = [255 255 255
%     230 230 230
%     20 20 20
%     50 205 110
%     250 216 0
%     30 100 255
%     255 40 75
%     20 100 255
%     50 75 255
%     0 153 255];
% 
% cmap = cmap/255;

figure()
im(kMeansImg)
colorbar
caxis([1 k])
colormap(cmap)
title(sprintf('k-Means Clustering with %d Clusters',k))
xlabel('Position (Pixels)')
ylabel('Position (Pixels)')

    