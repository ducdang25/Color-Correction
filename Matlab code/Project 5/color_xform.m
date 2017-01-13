function [cal_img, a, fit, proc_mean, proc_mean2, orig_mean] = color_xform(orig_img, orig_top, orig_left, orig_bot, orig_right, ...
orig_patch_info, proc_img, proc_top, proc_left, proc_bot, proc_right, robust, nonlinear);
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

order = 3;
fit = zeros (order+1,3);
% Check image sizes
if (size(orig_img) ~= size(proc_img))
    disp('The original and processed images must have the same dimensions');
    return
end

% Find the total number of color patches
n = size(orig_patch_info,1);

% Compute the translation and scale between the original color
% chart patches and the processed color chart patches.
proc_patch_info = zeros(n,4);
r_scale = (proc_bot-proc_top)/(orig_bot-orig_top); % row size scale factor
proc_patch_info(:,3) = orig_patch_info(:,3)*r_scale;
c_scale = (proc_right-proc_left)/(orig_right-orig_left); % col size scale factor
proc_patch_info(:,4) = orig_patch_info(:,4)*c_scale;
r_shift = proc_top - r_scale*orig_top; % row shift after size scaling
proc_patch_info(:,1) = r_scale*orig_patch_info(:,1) + r_shift;
c_shift = proc_left - c_scale*orig_left; % col shift after size scaling
proc_patch_info(:,2) = c_scale*orig_patch_info(:,2) + c_shift;
% Round processed patch indices to the nearest integer
proc_patch_info = round(proc_patch_info);

% Calculate the R, G, B mean of each patch.
orig_mean = zeros(n,3);
proc_mean = zeros(n,3);
for i = 1:n
    % Original image
    or_1 = orig_patch_info(i,1); % top coordinate of orig patch
    oc_1 = orig_patch_info(i,2); % left coordinate of orig patch
    or_2 = orig_patch_info(i,1) + orig_patch_info(i,3) - 1; % bottom coordinate of original patch
    oc_2 = orig_patch_info(i,2) + orig_patch_info(i,4) - 1; % right coordinate of original patch
    orig_mean(i,:) = ...
        mean(reshape(orig_img(or_1:or_2, oc_1:oc_2, :),orig_patch_info(i,3)*orig_patch_info(i,4),3));
    % Processed image
    cr_1 = proc_patch_info(i,1); % top coordinate of processed patch
    cc_1 = proc_patch_info(i,2); % left coordinate of processed patch
    cr_2 = proc_patch_info(i,1) + proc_patch_info(i,3) - 1; % bottom coordinate of processed patch
    cc_2 = proc_patch_info(i,2) + proc_patch_info(i,4) - 1; % right coordinate of processed patch
    proc_mean(i,:) = ...
        mean(reshape(proc_img(cr_1:cr_2, cc_1:cc_2, :),proc_patch_info(i,3)*proc_patch_info(i,4),3));
end

% Free up memory
clear orig_img
% Plot results and store figures
figure(4)
hold on
plot(proc_mean(:,1), orig_mean(:,1),'r.','markersize', 15);
grid on
set(gca,'LineWidth',1)
set(gca,'FontName','Ariel')
set(gca,'fontsize',12)
xlabel('Processed Mean Red')
ylabel('Original Mean Red')
title('Orig Mean Red vs. Proc Mean Red')
hold off
print -depsc2 -tiff figure4
print -dpng figure4

figure(5)
hold on
plot(proc_mean(:,2), orig_mean(:,2),'g.', 'markersize', 15);
grid on
set(gca,'LineWidth',1)
set(gca,'FontName','Ariel')
set(gca,'fontsize',12)
xlabel('Processed Mean Green')
ylabel('Original Mean Green')
title('Orig Mean Green vs. Proc Mean Green')
hold off
print -depsc2 -tiff figure5
print -dpng figure5

figure(6)
hold on
plot(proc_mean(:,3), orig_mean(:,3),'b.', 'markersize', 15);
grid on
set(gca,'LineWidth',1)
set(gca,'FontName','Ariel')
set(gca,'fontsize',12)
xlabel('Processed Mean Blue')
ylabel('Original Mean Blue')
title('Orig Mean Blue vs. Proc Mean Blue')
hold off
print -depsc2 -tiff figure6
print -dpng figure6

% Apply a pre monotonic non-linear transformation on R, G, and B (individually) if requested.
if (nonlinear == -1)
    proc_mean_nlin = zeros(n,3);
    [fit(:,1), proc_mean_nlin(:,1)] = polyfit_monotonic(proc_mean(:,1), orig_mean(:,1), 3);
    [fit(:,2), proc_mean_nlin(:,2)] = polyfit_monotonic(proc_mean(:,2), orig_mean(:,2), 3);
    [fit(:,3), proc_mean_nlin(:,3)] = polyfit_monotonic(proc_mean(:,3), orig_mean(:,3), 3);
    
    % Plot results and store figures.
    figure(10)
    hold on
    plot(proc_mean(:,1),proc_mean_nlin(:,1),'.r', 'markersize', 15);
    grid on
    set(gca,'LineWidth',1)
    set(gca,'FontName','Ariel')
    set(gca,'fontsize',12)
    xlabel('Red Before Non-linear Transformation')
    ylabel('Red After Non-linear Transformation')
    title('Non-linear Red Transformation')
    hold off
    print -depsc2 -tiff figure10
    print -dpng figure10
    
    figure(11)
    hold on
    plot(proc_mean(:,2),proc_mean_nlin(:,2),'.g', 'markersize', 15);
    grid on
    set(gca,'LineWidth',1)
    set(gca,'FontName','Ariel')
    set(gca,'fontsize',12)
    xlabel('Green Before Non-linear Transformation')
    ylabel('Green After Non-linear Transformation')
    title('Non-linear Green Transformation')
    hold off
    print -depsc2 -tiff figure11
    print -dpng figure11
    
    figure(12)
    hold on
    plot(proc_mean(:,3),proc_mean_nlin(:,3),'.b', 'markersize', 15);
    grid on
    set(gca,'LineWidth',1)
    set(gca,'FontName','Ariel')
    set(gca,'fontsize',12)
    xlabel('Blue Before Non-linear Transformation')
    ylabel('Blue After Non-linear Transformation')
    title('Non-linear Blue Transformation')
    hold off
    print -depsc2 -tiff figure12
    print -dpng figure12
    
    % Re-assign proc_mean to proc_mean_nlin in preparation for color matrix calculation
    proc_mean = proc_mean_nlin;
end

% Add col of ones to proc_mean in preparation for linear fit
proc_mean = [ones(n,1) proc_mean];

% Calculate a using least squares fit: all points equally weighted.
a = proc_mean\orig_mean;
save('a.mat','a');

% Calculate a using iterative robust fitting option that reduces the weight of outliers.
if (robust)
    max_tries  = 1000; % Maximum number of tries per each robust fit
    max_change = .0001; % Maximum change allowed on each matrix element before stopping
    i_try = 0;
    this_change = inf; % initial large number to force execution of while loop
    
    while ((i_try <= max_tries) & (this_change > max_change))
        i_try = i_try + 1;
        last_a = a;
        % Decrease the weight on the outliers and perform new fit
        err = orig_mean - proc_mean*a; % error on each R, G, and B component, sample by sample
        err = sqrt(err(:,1).^2 + err(:,2).^2 + err(:,3).^2); % Euclidean error for each RGB sample
        cost = 1./(err+.1); % cost vector is inverse of error, limited to prevent divide by zero
        cost = cost./norm(cost); % normalize the cost vector
        cost2 = cost.*cost; % square the cost vector
        cost2_mat = sparse(1:n,1:n,cost2,n,n); % create the cost matrix
        a = inv(proc_mean'*cost2_mat*proc_mean)*proc_mean'*cost2_mat*orig_mean; % updated a
        this_change = max(max(abs(a-last_a))); % calculate them maximum change in the a elements
    end
end

% Apply a post monotonic non-linear transformation on R, G, and B (individually) if requested.
if (nonlinear == 1)
    orig_mean_hat = proc_mean*a;
    orig_mean_hat_nlin = zeros(n,3);
    [fit(:,1), orig_mean_hat_nlin(:,1)] = polyfit_monotonic(orig_mean_hat(:,1), orig_mean(:,1), 3);
    [fit(:,2), orig_mean_hat_nlin(:,2)] = polyfit_monotonic(orig_mean_hat(:,2), orig_mean(:,2), 3);
    [fit(:,3), orig_mean_hat_nlin(:,3)] = polyfit_monotonic(orig_mean_hat(:,3), orig_mean(:,3), 3);
    
    % Plot results and store figures.
    figure(10)
    hold on
    plot(orig_mean_hat(:,1),orig_mean_hat_nlin(:,1),'.r', 'markersize', 15);
    grid on
    set(gca,'LineWidth',1)
    set(gca,'FontName','Ariel')
    set(gca,'fontsize',12)
    xlabel('Red Before Non-linear Transformation')
    ylabel('Red After Non-linear Transformation')
    title('Non-linear Red Transformation')
    hold off
    print -depsc2 -tiff figure10
    print -dpng figure10
    
    figure(11)
    hold on
    plot(orig_mean_hat(:,2),orig_mean_hat_nlin(:,2),'.g', 'markersize', 15);
    grid on
    set(gca,'LineWidth',1)
    set(gca,'FontName','Ariel')
    set(gca,'fontsize',12)
    xlabel('Green Before Non-linear Transformation')
    ylabel('Green After Non-linear Transformation')
    title('Non-linear Green Transformation')
    hold off
    print -depsc2 -tiff figure11
    print -dpng figure11
    
    figure(12)
    hold on
    plot(orig_mean_hat(:,3),orig_mean_hat_nlin(:,3),'.b', 'markersize', 15);
    grid on
    set(gca,'LineWidth',1)
    set(gca,'FontName','Ariel')
    set(gca,'fontsize',12)
    xlabel('Blue Before Non-linear Transformation')
    ylabel('Blue After Non-linear Transformation')
    title('Non-linear Blue Transformation')
    hold off
    print -depsc2 -tiff figure12
    print -dpng figure12
end

% Calculate the calibrated processed image (cal_img).
% Find the total number of rows and columns in proc_img
[nr, nc, planes] = size(proc_img);

if (nonlinear == 0)
    % Apply the matrix fit that was calculated to find the final processed image.
    cal_img = double([ones(nr*nc,1) reshape(permute(proc_img,[3,1,2]), 3, nr*nc)'])*a;
end

if (nonlinear == 1)
    % Apply the color matrix fit first.
    cal_img = [ones(nr*nc,1) reshape(permute(proc_img,[3,1,2]), 3, nr*nc)'] * a;
    % Then apply the nonlinear transform function that was found on each R, G, and B component.
    cal_img(:,1) = polyval(fit(:,1), cal_img(:,1));
    cal_img(:,2) = polyval(fit(:,2), cal_img(:,2));
    cal_img(:,3) = polyval(fit(:,3), cal_img(:,3));
end

if (nonlinear == -1)
    % Apply the nonlinear transform function that was found on each R, G, and B component first.
    cal_img = zeros(nr*nc,planes);
    proc_img_reshape = reshape(permute(proc_img,[3,1,2]), 3, nr*nc)';
    cal_img(:,1) = polyval(fit(:,1), proc_img_reshape(:,1));
    cal_img(:,2) = polyval(fit(:,2), proc_img_reshape(:,2));
    cal_img(:,3) = polyval(fit(:,3), proc_img_reshape(:,3));
    clear proc_imge_reshape
    % Then apply the color matrix fit.
    cal_img = [ones(nr*nc,1) cal_img] * a;
end

% Reformat cal_img
cal_img = reshape(cal_img, nr, nc,3);
% Calculate the R, G, B mean of each patch in new calibrated image.
proc_mean2 = zeros(n,3);
for i = 1:n
    % Processed image
    cr_1 = proc_patch_info(i,1); % top coordinate of processed patch
    cc_1 = proc_patch_info(i,2); % left coordinate of processed patch
    cr_2 = proc_patch_info(i,1) + proc_patch_info(i,3) - 1; % bottom coordinate of processed patch
    cc_2 = proc_patch_info(i,2) + proc_patch_info(i,4) - 1; % right coordinate of processed patch
    proc_mean2(i,:) = ...
        mean(reshape(cal_img(cr_1:cr_2, cc_1:cc_2, :),proc_patch_info(i,3)*proc_patch_info(i,4),3));
end

% Plot results versus original and store figures.
figure(7)
hold on
plot(proc_mean2(:,1), orig_mean(:,1),'r.', 'markersize', 15);
grid on
set(gca,'LineWidth',1)
set(gca,'FontName','Ariel')
set(gca,'fontsize',12)
xlabel('Final Fitted Processed Mean Red')
ylabel('Original Mean Red')
title('Orig Mean Red vs. Final Fitted Proc Mean Red')
hold off
print -depsc2 -tiff figure7
print -dpng figure7

figure(8)
hold on
plot(proc_mean2(:,2), orig_mean(:,2), 'g.', 'markersize', 15);
grid on
set(gca,'LineWidth',1)
set(gca,'FontName','Ariel')
set(gca,'fontsize',12)
xlabel('Final Fitted Processed Mean Green')
ylabel('Original Mean Green')
title('Orig Mean Green vs. Final Fitted Proc Mean Green')
hold off
print -depsc2 -tiff figure8
print -dpng figure8

figure(9)
hold on
plot(proc_mean2(:,3), orig_mean(:,3), 'b.', 'markersize', 15);
grid on
set(gca,'LineWidth',1)
set(gca,'FontName','Ariel')
set(gca,'fontsize',12)
xlabel('Final Fitted Processed Mean Green')
ylabel('Original Mean Blue')
title('Orig Mean Blue vs. Final Fitted Proc Mean Blue')
hold off
print -depsc2 -tiff figure9
print -dpng figure9
