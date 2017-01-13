clc; close all; clear all;
[orig, patch_info] = generate_chart (320, 480, 24, 16, 240, 16, 240, 16, 240, 8, 16);

%prog = orig;
%save('patch_info.mat','patch_info');

%[cal_img, a, fit] = color_xform(orig, 1, 1, 480, 320, patch_info, prog, 1, 1, 480, 320, 0, -1);
