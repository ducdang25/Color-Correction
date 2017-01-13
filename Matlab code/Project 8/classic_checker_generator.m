%rawImg = imread('frame_330.png');
%imshow(rawImg);
%[I2,rect]=imcrop(rawImg);

%[chart_classic,info] = generate_chart(768,1024,8,8);
clc; close all; clear all;
nrows = 320;
ncols = 476;
spacing = 8;
safety = 16;
nrgb = 24;
chart = zeros(nrows, ncols, 3); % Initial chart will contain all black
rgb = zeros(nrgb,3); % holds the RGB color of each patch
rgb(1,:)  = [115 82 68];
rgb(2,:)  = [194 150 130];
rgb(3,:)  = [98 122 157];
rgb(4,:)  = [87 108 67];
rgb(5,:)  = [133 128 177];
rgb(6,:)  = [103 189 170];
rgb(7,:)  = [214 126 44];
rgb(8,:)  = [80 91 166];
rgb(9,:)  = [193 90 99];
rgb(10,:) = [94 60 108];
rgb(11,:) = [157 188 64];
rgb(12,:) = [224 163 46];
rgb(13,:) = [56 61 150];
rgb(14,:) = [70 148 73 ];
rgb(15,:) = [175 54 60];
rgb(16,:) = [231 199 31];
rgb(17,:) = [187 86 149];
rgb(18,:) = [8 133 161];
rgb(19,:) = [243 243 242];
rgb(20,:) = [200 200 200];
rgb(21,:) = [160 160 160];
rgb(22,:) = [122 122 121];
rgb(23,:) = [85 85 85];
rgb(24,:) = [52 52 52];

nc_p = 6; % number of patches in the col direction, round up
nr_p = 4; % number of patches in the row direction (will round as needed)
%if (floor(nr_p)*nc_p >= nrgb)
%    nr_p = floor(nr_p);
%else
%    nr_p = ceil(nr_p);
%end

sc_p = 70; % col size of each patch (in pixels)
sr_p = 70; % row size of each patch (in pixels)
% Contains the first row, first col, row size, and column size of each color patch, in that
% order.
patch_info = zeros(nrgb,4);

% Fill two dimensional grid from left to right by rows
this_col = 0;
this_row = 1;
for i=1:nrgb % step through color patches
    this_col = this_col +1;
    if (this_col > nc_p) % go to next row, this one is full
       this_row = this_row+1;
       this_col = 1;
    end
    index = (this_row-1)*nc_p + this_col;
    beg_col = spacing*this_col + sc_p*(this_col-1) + 1; % beginning col coordinate for patch
    beg_row = spacing*this_row + sr_p*(this_row-1) + 1; % beginning row coordinate for patch
    patch_info(index,:) = [beg_row beg_col sr_p sc_p];
    chart(beg_row:beg_row+sr_p-1, beg_col:beg_col+sc_p-1, :) = ...
    cat(3,repmat(rgb(i,1),sr_p,sc_p),repmat(rgb(i,2),sr_p,sc_p),repmat(rgb(i,3),sr_p,sc_p));
end

% Add safety margin to the color patch information
%patch_info = patch_info + repmat([safety safety -2*safety -2*safety], nrgb,1);
% Uncomment this line to display the chart
figure
image(chart/255);
% Uncomment this line to write out the test chart in tif format.
imwrite(uint8(chart),'chart_classic.png','png');
%save('patch_info.mat','patch_info');