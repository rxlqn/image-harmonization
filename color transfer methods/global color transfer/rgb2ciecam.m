function AC1C2 = rgb2ciecam(RGB)

% AC1C2 = rgb2lab(RGB)
%
% This uses the following color space conversion: Reinhard01CGA_color.
% Both AC1C2 and RGB are nx3 matrix of double values.
%
% Wei Xu
% July 2009

% from rgb to linear lms
M1 = [0.3811 0.5783 0.0402;
      0.1967 0.7244 0.0782;
      0.0241 0.1288 0.8444];
LMS = [M1 * RGB']';

% from linear lms to ac1c2
M2 = [2.00 1.00 0.05;
      1.00 -1.09 0.09;
      0.11 0.11 -0.22];
AC1C2 = [M2 * LMS']';

