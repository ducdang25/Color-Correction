clc; close all; clear all;
orig = imread('chart_classic.png');
prog = imread('chart_processed.png');

figure; image(orig);
figure; image(prog);

[cal_img, a] = color_xform(orig, prog);

figure; imshow(cal_img/255);