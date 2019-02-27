function phi =calcphi(H, alpha, beta, n)
% calcphi Calculate phi for hdr compression
% accepts H (the log transformed image), alpha, beta, and
% n (the number of resolution levels minus 1)
% from "Gradient domain high dynamic range compression"
% doi:10.1145/566570.566573

phi = ones(size(H));
[sR, sC] = size(H);
X = [1:sC];
Y = [1:sR]';
for k = 0:n
    [Hdxp, Hdyp] = centraldiff(H);
    gradmag = sqrt(Hdxp .^ 2 + Hdyp .^ 2) / 2.0 ^ k;
    p = alpha ./ gradmag .* (gradmag ./ alpha) .^ beta;
    p(isnan(p)) = 1;
    Xsamples = X(1:2^k:end) + 2^k / 2 - 0.5;
    Ysamples = Y(1:2^k:end) + 2^k / 2 - 0.5;
    phitmp = interp2(Xsamples, Ysamples, p, X, Y, 'spline');
    phi = phi .* phitmp;
    if mod(size(H, 1), 2) ~= 0 || mod(size(H, 2), 2) ~= 0
        error('Cannot reduce image further. Reduce n or change image size');
    end
    H = impyramid(H, 'reduce');
end
end


function [dx, dy] = centraldiff(img)
    dx = zeros(size(img));
    dx(:, 2:end - 1) = (img(:, 3:end) - img(:, 1:end - 2)) / 2.0;
    dy = zeros(size(img));
    dy(2:end - 1, :) = (img(3:end, :) - img(1:end - 2, :)) / 2.0;

end