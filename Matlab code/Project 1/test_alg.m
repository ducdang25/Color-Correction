clc; close all;
orig = imread('orig.png');
prog = imread('prog.png');

figure; imshow(orig);
figure; imshow(prog);

patch_info = load('patch_info.mat');
[cal_img, a, fit, proc_mean, proc_mean2, orig_mean, i_try] = color_xform(orig, 1, 1, 480, 320, patch_info.patch_info, prog, 1, 1, 480, 320, 1, 0);

figure; imshow(cal_img/255);

orig2 = imread('orig2.jpg');
prog2 = imread('prog2.jpg');

figure; imshow(orig2);
figure; imshow(prog2);

[nr, nc, planes] = size(prog2);
cal_img2 = double([ones(nr*nc,1) reshape(permute(prog2,[3,1,2]), 3, nr*nc)'])*a;
cal_img2 = reshape(cal_img2, nr, nc,3);
figure; imshow(cal_img2/255);