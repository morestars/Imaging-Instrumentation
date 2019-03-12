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

%% Analysis
% load in image
img_log = log10(img);
der = [0 1 0; 1 -4 1; 0 1 0]; % kernel to take the derivative
img_der = conv2(img_log,der);
img_der = img_der(2:1025,2:1281);
img = imread('cameraman.tif');

% r0 = b - Ax0
b = conv2(img,der,'same');
x = ones(size(img));
Ax = conv2(x,der,'same');
r = b - Ax;
p = r;
rCrit = sum(abs(r),'all')/numel(r);
%% Finding Ax from b by minimizing r
i = 1;
while rCrit > 1e-3
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
end

%% Setting masks

% load in all the iamges



