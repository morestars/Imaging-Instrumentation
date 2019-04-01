%% Lab 6: Optical Tomography

%% Stage Setup
s = APT.getstage('rotation');

%% Camera Setup
c = Camera(0);
c.pixelclock = 7;
c.frameraterange = [0.5, 1];
c.exposure = 5; 
c.aoi = [0, 0, 1280, 1024];

%% Acquisition

img = zeros(600,1280,361);
s.move_abs(0);
for i = 1:360
    p = s.position;
    disp(p)
    a = c.capture();
    a = flip(a);
    a = imrotate(a,270);
    img(:,:,i) = a;
    s.move_abs(i);
end

%% 
img0 = img;


