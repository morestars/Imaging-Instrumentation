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

mask(:,:,1) = ones(1280,1024);
maskedImg = IMG .* mask;

%% Photons
photonCounts = [];
for i = 1:234
    photonCounts = [photonCounts sum(refIMG(:,:,i),'all')];
end
expTimes = 0.01:0.01:0.1;
expTimes = [expTimes 0.1:0.1:1];
expTimes = [expTimes 1:1:10];
expTimes = [expTimes 21:1:130];
expTimes = [expTimes 130:10:1000];
expTimes = [expTimes 1500:100:1900];
expTimes = [expTimes 1999];

photonsPerExposure = photonCounts./expTimes;

phtnNormImg = zeros(size(refIMG));
for i = 1:234
    %phtnNormImg(:,:,i) = maskedImg(:,:,i)/expTimes(i);
    phtnNormImg(:,:,i) = maskedImg(:,:,i)*photonsPerExposure(i);
end

%% More image manipulation

DRsum = sum(phtnNormImg,3);
DRmask = sum(mask,3);
DRimg = DRsum./DRmask;

logImg = log10(DRimg);
%logImg = logImg - mean(logImg,'all'); % attenuate edge edges
%logImg = logImg + min(logImg,[],'all');

der = [0 1 0; 1 -4 1; 0 1 0]; % kernel to take the derivative
derImg = conv2(logImg,der,'same');
derImg = derImg - mean(derImg,'all');
%derImg = derImg(2:1279,2:1023);
derImg(1,:) = derImg(2,:);
derImg(1280,:) = derImg(1279,:);
derImg(:,1) = derImg(:,2);
derImg(:,1024) = derImg(:,1023);
% derImg = derImg + abs(min(derImg,[],'all'));

%% Phi

phi = calcphi(derImg, abs(mean(derImg,'all'))*100, 0.8, 3);
atImg = phi .* derImg;
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
img = derImg;
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
