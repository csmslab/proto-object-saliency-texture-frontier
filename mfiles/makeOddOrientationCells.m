function [msk1, msk2] =  makeOddOrientationCells(theta,lambda,sigma,gamma)
%Makes  odd gabor filter
%
%inputs:
%theta - orientation of gabor filter
%lamba - wavelength of gabor filter
%sigma - std of gaussian envelope in gabor filter
%gamma - aspect ratio of gabor filter
%
%outputs:
%msk1 - odd-gabor filter polarity 1
%msk2 - odd-gabor filter polarity 2
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

if nargin ~= 4
    error('Incorrect number of inputs for makeOddOrientationCells');
end

if (nargin ~= 4)
    error('Incorrect number of input arguments for makeEvenOrientationCells');
end
sigma_x= sigma;
sigma_y = sigma/gamma;
 
% Bounding box
nstds = 2;
xmax = max(abs(nstds*sigma_x*cos(pi/2-theta)),abs(nstds*sigma_y*sin(pi/2-theta)));
xmax = ceil(max(1,xmax));
ymax = max(abs(nstds*sigma_x*sin(pi/2-theta)),abs(nstds*sigma_y*cos(pi/2-theta)));
ymax = ceil(max(1,ymax));
xmin = -xmax; ymin = -ymax;
[x,y] = meshgrid(xmin:xmax,ymin:ymax);
 
% Rotation 

x_theta=x*cos(pi/2-theta)+y*sin(pi/2-theta);
y_theta=-x*sin(pi/2-theta)+y*cos(pi/2-theta);

msk1 = 1/(2*pi*sigma_x *sigma_y) * exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*sin(2*pi/lambda*x_theta);
msk1 = msk1-mean(mean(msk1));

msk2 = 1/(2*pi*sigma_x *sigma_y) * exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*sin(2*pi/lambda*x_theta+pi);
msk2 = msk2-mean(mean(msk2));
