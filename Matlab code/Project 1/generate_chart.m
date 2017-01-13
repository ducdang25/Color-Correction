function [chart, patch_info] = generate_chart(nrows, ncols, nrgb, low_red, high_red, ...
low_green, high_green, low_blue, high_blue, spacing, safety)
% function [chart, patch_info] = generate_chart(nrows, ncols, nrgb, low_red, high_red, ...
% low_green, high_green, low_blue, high_blue, spacing, safety);
%
% The function generate_chart returns two variables:
% chart - the generated color chart
% patch_info - a nrgb X 4 matrix that specifies where each individual color patch is
% located within the color chart. For each color patch, this information is
% specified as the first row position, the first column position, the row size,
% and the column size, in that order.
%
% The random RGB color chart is generated according to user-specified inputs:
% nrows - total number of pixels, or rows, in the vertical direction (e.g, 1704)
% ncols - total number of pixels, or cols, in the horizontal direction (e.g., 2272)
% nrgb - number of red, green, and blue combinations, or color patches (e.g., 4)
% low_red - the lowest red value to include (e.g., 0)
% high_red - the highest red value to include (e.g., 255)
% low_green - the lowest green value to include (e.g., 0)
% high_green - the highest green value to include (e.g., 255)
% low_blue - the lowest blue value to include (e.g., 0)
% high_blue - the highest blue value to include (e.g., 255)
% spacing - number of black border pixels between different color patches (e.g., 8)
% safety - the safety margin (e.g., 16) to add to the patch_info to eliminate transitions
% between the color patches in the least squares estimate routine. Safety
% is added to the patch start locations and 2*safety is subtracted from the
% patch sizes to provide a safety border all the way around the patch.
chart = zeros(nrows, ncols, 3); % Initial chart will contain all black
% The code will compute nrgb color samples randomly spaced from their respective
% low to high values. These colors are then mapped to a two dimensional color chart.
% Initialize random number generator and generate random color patches
rand('state',sum(100*clock));
rgb = zeros(nrgb,3); % holds the RGB color of each patch
for i = 1:nrgb
    red = round(low_red-0.5+(1+high_red-low_red)*rand);
    green = round(low_green-0.5+(1+high_green-low_green)*rand);
    blue = round(low_blue-0.5+(1+high_blue-low_blue)*rand);
    rgb(i,:) = [red green blue];
end

% Distribute patches equally in row and col directions of color chart. If these values are
% not integers, then the chart will not be completely filled.
nc_p = ceil(sqrt(nrgb)); % number of patches in the col direction, round up
nr_p = sqrt(nrgb); % number of patches in the row direction (will round as needed)
if (floor(nr_p)*nc_p >= nrgb)
    nr_p = floor(nr_p);
else
    nr_p = ceil(nr_p);
end

sc_p = floor((ncols - spacing*(nc_p+1))/nc_p); % col size of each patch (in pixels)
sr_p = floor((nrows - spacing*(nr_p+1))/nr_p); % row size of each patch (in pixels)
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
patch_info = patch_info + repmat([safety safety -2*safety -2*safety], nrgb,1);
% Uncomment this line to display the chart
figure
image(chart/255);
% Uncomment this line to write out the test chart in tif format.
imwrite(uint8(chart),'chart.png','png');