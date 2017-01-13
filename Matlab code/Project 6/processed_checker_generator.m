clc; close all; clear all;
patch_extractor;
close all;
nrows = 320;
ncols = 476;
spacing = 8;
safety = 16;
nrgb = 24;
chart = zeros(nrows, ncols, 3); % Initial chart will contain all black
patch_info = load('patch_info.mat');
patch_info = (patch_info.patch_info);
%for i = 1:nrgb
   %subpatch = 
chart(patch_info(1,1):(patch_info(1,1)-1+patch_info(1,3)), patch_info(1,2):(patch_info(1,2)-1+patch_info(1,4)),:)= patch1;
chart(patch_info(2,1):(patch_info(2,1)-1+patch_info(2,3)), patch_info(2,2):(patch_info(2,2)-1+patch_info(2,4)),:)= patch2;
chart(patch_info(3,1):(patch_info(3,1)-1+patch_info(3,3)), patch_info(3,2):(patch_info(3,2)-1+patch_info(3,4)),:)= patch3;
chart(patch_info(4,1):(patch_info(4,1)-1+patch_info(4,3)), patch_info(4,2):(patch_info(4,2)-1+patch_info(4,4)),:)= patch4;



chart(patch_info(5,1):(patch_info(5,1)-1+patch_info(5,3)), patch_info(5,2):(patch_info(5,2)-1+patch_info(5,4)),:)= patch5;
chart(patch_info(6,1):(patch_info(6,1)-1+patch_info(6,3)), patch_info(6,2):(patch_info(6,2)-1+patch_info(6,4)),:)= patch6;
chart(patch_info(7,1):(patch_info(7,1)-1+patch_info(7,3)), patch_info(7,2):(patch_info(7,2)-1+patch_info(7,4)),:)= patch7;
chart(patch_info(8,1):(patch_info(8,1)-1+patch_info(8,3)), patch_info(8,2):(patch_info(8,2)-1+patch_info(8,4)),:)= patch8;
chart(patch_info(9,1):(patch_info(9,1)-1+patch_info(9,3)), patch_info(9,2):(patch_info(9,2)-1+patch_info(9,4)),:)= patch9;
chart(patch_info(10,1):(patch_info(10,1)-1+patch_info(10,3)), patch_info(10,2):(patch_info(10,2)-1+patch_info(10,4)),:)= patch10;
chart(patch_info(11,1):(patch_info(11,1)-1+patch_info(11,3)), patch_info(11,2):(patch_info(11,2)-1+patch_info(11,4)),:)= patch11;
chart(patch_info(12,1):(patch_info(12,1)-1+patch_info(12,3)), patch_info(12,2):(patch_info(12,2)-1+patch_info(12,4)),:)= patch12;
chart(patch_info(13,1):(patch_info(13,1)-1+patch_info(13,3)), patch_info(13,2):(patch_info(13,2)-1+patch_info(13,4)),:)= patch13;
chart(patch_info(14,1):(patch_info(14,1)-1+patch_info(14,3)), patch_info(14,2):(patch_info(14,2)-1+patch_info(14,4)),:)= patch14;
chart(patch_info(15,1):(patch_info(15,1)-1+patch_info(15,3)), patch_info(15,2):(patch_info(15,2)-1+patch_info(15,4)),:)= patch15;
chart(patch_info(16,1):(patch_info(16,1)-1+patch_info(16,3)), patch_info(16,2):(patch_info(16,2)-1+patch_info(16,4)),:)= patch16;
chart(patch_info(17,1):(patch_info(17,1)-1+patch_info(17,3)), patch_info(17,2):(patch_info(17,2)-1+patch_info(17,4)),:)= patch17;
chart(patch_info(18,1):(patch_info(18,1)-1+patch_info(18,3)), patch_info(18,2):(patch_info(18,2)-1+patch_info(18,4)),:)= patch18;
chart(patch_info(19,1):(patch_info(19,1)-1+patch_info(19,3)), patch_info(19,2):(patch_info(19,2)-1+patch_info(19,4)),:)= patch19;
chart(patch_info(20,1):(patch_info(20,1)-1+patch_info(20,3)), patch_info(20,2):(patch_info(20,2)-1+patch_info(20,4)),:)= patch20;
chart(patch_info(21,1):(patch_info(21,1)-1+patch_info(21,3)), patch_info(21,2):(patch_info(21,2)-1+patch_info(21,4)),:)= patch21;
chart(patch_info(22,1):(patch_info(22,1)-1+patch_info(22,3)), patch_info(22,2):(patch_info(22,2)-1+patch_info(22,4)),:)= patch22;
chart(patch_info(23,1):(patch_info(23,1)-1+patch_info(23,3)), patch_info(23,2):(patch_info(23,2)-1+patch_info(23,4)),:)= patch23;
chart(patch_info(24,1):(patch_info(24,1)-1+patch_info(24,3)), patch_info(24,2):(patch_info(24,2)-1+patch_info(24,4)),:)= patch24;

%end 
%= patch1;
image(chart/255);
imwrite(uint8(chart),'chart_processed_GalaxyEdge.png','png');

