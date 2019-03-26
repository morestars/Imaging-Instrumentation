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

%}

%% Camera setup
c = Camera(0);
c.pixelclock = 7;
c.frameraterange = [0.5, 1];
c.exposure = 16; % for both nontransmissive and transmissive scenes
% c.exposure = 1; % for no filter nontransmissive
% c.exposure = 0.9 % for no filter transmissive bean and bee
% aperature = 2.8 on day 1 - 2.6 on day 2
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
    
    