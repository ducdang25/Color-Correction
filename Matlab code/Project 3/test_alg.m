clc; close all; clear all;
orig = imread('Galaxy1.jpg');
prog = imread('Moto1.jpg');

figure; imshow(orig);
figure; imshow(prog);


%prog(:,3) = prog(:,3).*2;
% function [cal_img, a, proc_mean, orig_mean] = color_xform(orig_img, proc_img)

% The following inputs control the least-squares fitting procedure:
% robust = 0 Perform a normal least-squares fit
% = 1 Perform a robust least-squares fit reducing outlier weights.
%
% nonlinear = 0 Do not perform a non-linear transform on R, G, and B (individually).
% = -1 Perform a non-linear transform on R, G, and B before the color matrix
% = 1 Perform a non-linear transform on R, B, and B after the color matrix

%patch_info = load('patch_info.mat');
%ImgVector = orig(:,:,:);
[cal_img, a] = color_xform(orig, prog);

figure; imshow(cal_img/255);




orig2 = imread('orig2.jpg');
prog2 = imread('prog2.jpg');

figure; imshow(orig2);
figure; imshow(prog2);

[nr, nc, planes] = size(prog2);
cal_img2 = double([ones(nr*nc,1) reshape(permute(prog2,[3,1,2]), 3, nr*nc)'])*a;
cal_img2 = reshape(cal_img2, nr, nc,3);
figure; imshow(cal_img2/255);

imwrite(uint8(cal_img),'cal_img.jpg','jpg');
imwrite(uint8(cal_img2),'cal_img2.jpg','jpg');