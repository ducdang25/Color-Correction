function [cal_img, a] = color_xform(orig_img, proc_img)
% function [cal_img, a, fit] = color_xform(orig_img, orig_top, orig_left, orig_bot, orig_right, ...
% orig_patch_info, proc_img, proc_top, proc_left, proc_bot, proc_right, robust, nonlinear);
%
% Calculates and returns the calibrated color corrected processed image (cal_img), given an
% original image (orig_img) and a processed image (proc_img). orig_img and proc_img must have
% the same dimensions and are three dimensional with each third dimension holding the color
% image planes (e.g., R, G, B).
%
% If two output arguments are requested, also returns the 4 x 3 least squares color correction matrix
% transformation [A] that maps a processed image (proc_img) to the original image (orig_img)
% according to the following transformation:
%
% |orig_r_1 orig_g_1 orig_b_1| |1 proc_r_1 proc_g_1 proc_b_1|
% |orig_r_2 orig_g_2 orig_b_2| |1 proc_r_2 proc_g_2 proc_b_2|
% |orig_r_3 orig_g_3 orig_b_3| |1 proc_r_3 proc_g_3 proc_b_3|
% | . . . | = |. . . . | * [A]
% | . . . | |. . . . | 4 x 3
% | . . . | |. . . . |
% |orig_r_n orig_g_n orig_b_n| |1 proc_r_n proc_g_n proc_b_n|
% n x 3 n x 4
%
% In the above equation, n is the number of color patches that will be used to perform the
% least-squares estimate of A (see orig_patch_info below).
%
% If three output arguments are requested, also returns the non-linear pre-correction or post
% correction fit that was individually applied to the color components (see below).
%
% The image sub-region examined by the alogorithms is specified by TOP, LEFT, BOT, & RIGHT. If
% using a test chart, this image sub-region should be the top-left and bot-right corners of the
% test chart and include the black portion of the test chart for both the original image and the
% processed image. The top-left pixel in the image is defined as coordinate (1, 1). The image
% sub-regions of the original and processed images are compared and used to compute a linear
% transformation factor between the orig_patch_info and the corresponding patch information for
% the processed image. Thus, for example, a test chart contained within the original and
% processed images does not have to be the same size or located in the same horizontal and vertical
% position. However, the two sub-regions must not be rotated with respect to each other as this
% routine does not perform any rotational correction.
%
% orig_patch_info is a two dimensional matrix where each row specifies the following information
% about each color patch in the original image:
% first_row - the first row number of the color patch
% first_col - the first col number of the color patch
% row_size - the number of rows in the color patch
% col_size - the number of cols in the color patch
%
% The number of rows in orig_patch_info specifies the number of points n that will be used in the
% above least squares solution to find the color transformation matrix [A]. The user may want to add
% a safety margin to each beginning patch location and size since the entire patch area specified by
% the orig_patch_info matrix is averaged to produce low noise estimates of the color values for each
% patch before the least squares solution is calculated. Routine generate_chart can be used to obtain
% the orig_patch_info with a safety margin added.
%
% The following inputs control the least-squares fitting procedure:
% robust = 0 Perform a normal least-squares fit
% = 1 Perform a robust least-squares fit reducing outlier weights.
%
% nonlinear = 0 Do not perform a non-linear transform on R, G, and B (individually).
% = -1 Perform a non-linear transform on R, G, and B before the color matrix
% = 1 Perform a non-linear transform on R, B, and B after the color matrix
%
% Set the order of the non-linear fit. Use a polynomial of order 3 since this approximates
% non-linear s-curve responses.

% Check image sizes
if (size(orig_img) ~= size(proc_img))
    disp('The original and processed images must have the same dimensions');
    return
end

% Find the total number of color patches
% n = size(orig_patch_info,1);
[nr_orig, nc_orig, planes] = size(orig_img);
n = nr_orig*nc_orig;

% Original image
orig_mean = double(reshape(orig_img,n,3));
% Processed image
proc_mean = double(reshape(proc_img,n,3));

% Add col of ones to proc_mean in preparation for linear fit
proc_mean = [ones(n,1) proc_mean];

% Calculate a using least squares fit: all points equally weighted.
a = proc_mean\orig_mean;
save('a.mat','a');

% Calculate the calibrated processed image (cal_img).
% Find the total number of rows and columns in proc_img
[nr, nc, planes] = size(proc_img);

% Apply the matrix fit that was calculated to find the final processed image.
cal_img = double([ones(nr*nc,1) reshape(permute(proc_img,[3,1,2]), 3, nr*nc)'])*a;

% Reformat cal_img
cal_img = reshape(cal_img, nr, nc,3);
