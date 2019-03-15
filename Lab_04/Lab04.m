%% Lab 04

%% Setup
c = Camera(0);
c.framerate = 0.5;
c.exposure = 20;
c.pixelclock = 7;
c.aoi = [0, 0, 1280, 1024];

%% Acquisition
n = 1999;
img = zeros(1280, 1024, 5, length(n));
j = 1;
for i = n
    c.exposure = i;
    for k = 1:5
        img(:,:,k,j) = c.capture(); 
    end
    clear a
    a = img(:,:,1,j);
    a = flip(a);
    a = imrotate(a,270);
    im(a)
    
    j = j + 1;
end

%% Reformat images

IMG = [];
for i = 4:25
    loadFile = sprintf('img%d.mat', i);
    load(loadFile)
    imgString = sprintf('img%d', i);
    Img = eval(imgString);
    depth = size(Img,4);
    Img = mean(Img,3);
    Img = reshape(Img,[1280,1024,depth]);
    IMG = cat(3,IMG,Img);
end

load('img26.mat') % highest exposure, darkest regions
Img = mean(img26,3);
IMG = cat(3,IMG,Img); % add the highest exposure to the stack

refIMG = IMG;
clearvars -except refIMG IMG Img
%% Masks
% IMG is a 1280x1024x234 double, the third dimension represents the
% number of exposures captured
IMG = refIMG;
lowMask = 50;
highMask = 900;

% creates a logical matrix for every exposure setting
mask = (IMG > lowMask) .* (IMG <= highMask); 
% mask1 = (IMG > lowMask) .* (IMG <= highMask);
% 
% % load('img4.mat'); % lowest exposure, brightest regions
% % Img = mean(img4,3);
% % Img = Img(:,:,1,1);
% 
% mask2 = (Img > 50);
% IMG = cat(3,Img,IMG); %add the lowest exposure to the stack
% 
% load('img26.mat') % highest exposure, darkest regions
% Img = mean(img26,3);
% IMG = cat(3,IMG,Img); % add the highest exposure to the stack
% mask3 = (Img <= 900);
% 
% mask = cat(3,mask2,mask1);
% mask = cat(3,mask,mask3);

j = 0;
for i = size(IMG,3):-1:1 %back of stack==highest exposure, darkest regions
    IMG(:,:,i) = IMG(:,:,i)+((highMask-lowMask)*j);
    j = j+1;
end

figure()
im(IMG(:,:,234)),colormap(gray),colorbar

mask(:,:,1) = ones(1280,1024);
IMG = IMG .* mask;

%% More image manipulation

DRsum = sum(IMG,3);
DRmask = sum(mask,3);
DRimg = DRsum./DRmask;

logImg = log10(DRimg);
%logImg = logImg - mean(logImg,'all'); % attenuate edge edges
%logImg = logImg + min(logImg,[],'all');

der = [0 1 0; 1 -4 1; 0 1 0]; % kernel to take the derivative
derImg = conv2(logImg,der);
derImg = derImg(3:1280,3:1024);
% derImg(1,:) = derImg(2,:);
% derImg(1280,:) = derImg(1279,:);
% derImg(:,1) = derImg(:,2);
% derImg(:,1024) = derImg(:,1023);
% derImg = derImg + abs(min(derImg,[],'all'));

%% Phi

phi = calcphi(logImg, abs(mean(logImg,'all'))*0.01, 0.9, 2);
atImg = phi(2:1279,2:1023) .* derImg;
figure()
subplot(1,2,1)
im(atImg),colormap(gray),colorbar%,caxis([0 20])
subplot(1,2,2)
im(derImg),colormap(gray),colorbar%,caxis([0 20])

% 
% IMG(:,:,1) = IMG(:,:,1) + max(IMG(:,:,size(IMG,3)),[],'all');
%% Analysis Testing Junk Don't Run
% load in image
img_log = log10(img);
der = [0 1 0; 1 -4 1; 0 1 0]; % kernel to take the derivative
img_der = conv2(img_log,der);
img_der = img_der(2:1025,2:1281);
img = imread('cameraman.tif');
%% 
img = atImg;
% r0 = b - Ax0
%b = conv2(img,der,'same');
b = img;
x = ones(size(img));
%x = IMG(:,:,100);
Ax = conv2(x,der,'same');
r = b - Ax;
p = r;
rCrit = sum(abs(r),'all')/numel(r);
%% Finding Ax from b by minimizing r
i = 1;
while rCrit > 1e-4
    a = sum(r.^2,'all') / sum(p.*conv2(p,der,'same'),'all');
    x2 = x + a.*p;
    r2 = r - a.*conv2(p,der,'same');
    rCrit = sum(abs(r),'all')/numel(r);
    B = sum(r2.^2,'all') / sum(r.^2,'all');
    p2 = r2 + B.*p;
    p = p2;
    x = x2;
    r = r2;
    i = i+1;
    im(x), colormap(gray), colorbar
    drawnow
    disp(rCrit)
end

%%

expImg = 10.^x;
im(expImg), colormap(gray), colorbar
