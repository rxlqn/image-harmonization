function RGB = ciecam2rgb(AC1C2)

% RGB = ciecam2rgb(AC1C2)
%
% This uses the following color space conversion: Reinhard01CGA_color.
% Both AC1C2 and RGB are nx3 matrix of double values. RGB range is [0,1].
%
% Wei Xu
% July 2009

% from ac1c2 to linear lms
M1 = inv([2.00 1.00 0.05; 1.00 -1.09 0.09; 0.11 0.11 -0.22]);
LMS = [M1 * AC1C2']';

% from linear lms to rgb
% this transform maps the RGB white (RGB=(1,1,1)) to XYZ white (XYZ=(1,1,1)).
% note the origianl transform matrix used in the paper (eq.(9)) is wrong.
% M2 = [4.4679 -3.5873 0.1193;
%       -1.2186 2.3809 -0.1624;
%       0.0497 -0.2439 1.2045];
M2 = [4.4687   -3.5887    0.1196;
      -1.2197    2.3831   -0.1626;
      0.0585   -0.2611    1.2057];
RGB = [M2 * LMS']';
