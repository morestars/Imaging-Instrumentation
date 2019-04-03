%% Lab 6: Optical Tomography

%% Stage Setup
% often have to re-intialize the stage between uses
% when stage position p goes to 0, it may give an error. If so, rerun
% s.move_abs(0); and check that position is 0

s = APT.getstage('rotation');
s.move_abs(0);
p = s.position;
disp(p)

%% Camera Setup
% Use an aoi of [0, 700, 1280, 200] for 4/3/2019 to compress image data
% and maintain 200 possible lines of data to reconstruct cross-section
% from.

c = Camera(0);
c.pixelclock = 7;
c.frameraterange = [0.5, 1];
c.exposure = 5; 
c.aoi = [0, 700, 1280, 200];


%% Acquisition
% depth = 5 for 4/3/2019, yellowTubes and blank_v1 file, except for
% yellowTubes_filt2_v1 which only has depth = 1.

img = zeros(200,1280,364);
s.move_abs(0);
p = zeros(1,363);
depth = 5;
for i = 1:363
    p(i) = s.position;
    disp(p(i))
    a = zeros(1280,200,depth);
    for j = 1:depth
        a(:,:,j) = c.capture();
    end
    b = mean(a,3);
    b = flip(b);
    b = imrotate(b,270);
    img(:,:,i) = b;
    s.move_abs(i);
end




