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

img0 - no filter
img1 - 400 nm (violet)
img2 - 450 nm (blue)
img3 - 500 nm (blue-green)
img4 - 550 nm (green)
img5 - 600 nm (orange)
img6 - 650 nm (red)

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
% 
load('colors.mat');
%load('bean.mat');
%load('bee.mat');

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
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
title('A: No Filter')
subplot(3,3,4)
im(img1), colormap(gray), colorbar
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
title('B: 400 nm')
subplot(3,3,5)
im(img2), colormap(gray), colorbar
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
title('C: 450 nm')
subplot(3,3,6)
im(img3), colormap(gray), colorbar
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
title('D: 500 nm')
subplot(3,3,7)
im(img4), colormap(gray), colorbar
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
title('E: 550 nm')
subplot(3,3,8)
im(img5), colormap(gray), colorbar
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
title('F: 600 nm')
subplot(3,3,9)
im(img6), colormap(gray), colorbar
set(gca,'YTickLabel',[])
set(gca,'XTickLabel',[])
title('G: 650 nm')


%% The Function
load('transfer_functions.mat')

%{
(LT L+D{e}) -1 LT D{1./(b.*l.*s+e)} FT (FFT +D{e}) -1 ? A
%}

de = 1*ones(1,351);
De = diag(de);
De = 0.004;
Dbse = diag(1./(db2.*dl.*ds+de));


A = [];
for j = 1:7
    Afor1filter = [];
    for i = 1:3
        a = (L(:,i)'*L(:,i)+De)^(-1) * L(:,i)' * Dbse ...
            * F(j,:)' * (F(j,:) * F(j,:)'+De)^(-1);
        a = sum(a,2);
        Afor1filter = [Afor1filter a];
    end
    A = cat(1,A,Afor1filter);
end

    