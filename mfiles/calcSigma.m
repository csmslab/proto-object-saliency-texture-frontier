function [sigma1,sigma2] = calcSigma(r,x)
%calculates the sigma values for a Difference of Guassians to have a zero
%crossing at radius r.
%
%inputs:
%r - radius of inner gaussian
%x - multiplier for outer gaussian radius
%outputs:
%sigma1 - inner gauss standard deviation
%sigma2 outter gauss standard deviation


sigma1 = r^2/(4*log(x))*(1-1/x^2);
sigma1 = sqrt(sigma1);
sigma2 = x*sigma1;