clc; close all; clear all;
orig = imread('chart_classic.png');
prog = imread('chart_processed.png');

figure; image(orig);
figure; image(prog);

patch_info = load('patch_info.mat');
[cal_img1, a1, fit, proc_mean1, cal_mean1, orig_mean1] = color_xform(orig, 1, 1, 476, 320, patch_info.patch_info, prog, 1, 1, 476, 320, 0, 0);
imwrite(cal_img1/255,'cal_img1.png')
[cal_img2, a2, orig_mean2, proc_mean2, cal_mean2] = color_xform2(orig, 1, 1, 476, 320, patch_info.patch_info, prog, 1, 1, 476, 320);

error_ori1 = (orig_mean1 - proc_mean1(:,2:4)).^2;
error_fit1 = (orig_mean1 - cal_mean1).^2;
error_ori2 = (orig_mean1 - proc_mean2).^2;
error_fit2 = (orig_mean1 - cal_mean2).^2;

diff = error_fit1 - error_fit2;
sum_diff = sum(diff);
figure
hold on
plot(diff(:,1));
plot(diff(:,2));
plot(diff(:,3));
hold off

figure
hold on
plot(error_ori1(:,1));
plot(error_fit1(:,1));
hold off

figure
hold on
plot(error_ori1(:,2));
plot(error_fit1(:,2));
hold off

figure
hold on
plot(error_ori1(:,3));
plot(error_fit1(:,3));
hold off

figure
hold on
plot(error_ori2(:,1));
plot(error_fit2(:,1));
hold off

figure
hold on
plot(error_ori2(:,2));
plot(error_fit2(:,2));
hold off

figure
hold on
plot(error_ori2(:,3));
plot(error_fit2(:,3));
hold off

figure; image(cal_img/255);