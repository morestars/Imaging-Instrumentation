%% Lab 04

c = Camera(0);
c.framerate = 0.5;
c.exposure = 20;
c.pixelclock = 7;
c.aoi = [0, 0, 1280, 1024];

%%
n = 10:1:100;
img = zeros(1280, 1024, 5, length(n));
j = 1;
for i = 10:1:100
    c.exposure = i;
    for k = 1:5
        img(:,:,k,j) = c.capture();
    end
    j = j + 1;
end