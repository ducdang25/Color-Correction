clc; close all; clear all;
proc_img = imread('chart.png');
figure; imshow(proc_img);
nr = 320;
nc = 480;
permuted_img = permute(proc_img,[3,1,2]);
reshaped = reshape(permuted_img, 3, nr*nc)';
%cal_img = double([ones(nr*nc,1) reshape(permute(proc_img,[3,1,2]), 3, nr*nc)'])*a;
