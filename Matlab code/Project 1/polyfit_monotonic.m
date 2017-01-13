function [fit, yhat] = polyfit_monotonic(x, y, order);
% function [fit, yhat] = polyfit_monotonic(x, y, order);
%
% Perform a monotonic polynomial fit of column vector x to column vector y and returns
% the fit and estimated yhat. The order of the polynomial fit must be >= 1.
%
% Requires the use of optimization toolbox routine lsqlin.
%
% Catch to make sure order >= 1
if (order < 1)
    disp('Fitting order must be greater than or equal to 1');
end
% Find the size of the column vectors.
n = size(x,1);
% Create x and dx arrays. For the dx slope array (holds the derivatives of y with respect
% to x, the slope_sign specifies the direction of the slope that must not change over the
% x range.
x_temp = ones(n,1);
dx_temp = zeros(n,1);
slope_sign = 1;
for col = 1:order
    x_temp = [x_temp x.^col];
    dx_temp = [dx_temp col*x.^(col-1)];
end
% The lsqlin routine uses <= inequalities. Thus, if slope_sign is -1 (negative
% slope), we are correct but if slope_sign is +1 (positive slope), we must
% multiple dx by -1.
if (slope_sign == 1)
    dx_temp = -1*dx_temp;
end
% x fitted to y
fit = lsqlin(x_temp, y, dx_temp, zeros(n,1));
fit = flipud(fit); % organize this fit the same as what is output by polyfit
% yhat calculated
yhat = polyval(fit,x);