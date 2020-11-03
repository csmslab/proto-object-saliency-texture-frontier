function msk =  makeEvenOrientationCells(theta,lambda,sigma,gamma)
%Makes  even gabor filter
%
%inputs:
%theta - orientation of gabor filter
%lamba - wavelength of gabor filter
%sigma - std of gaussian envelope in gabor filter
%gamma - aspect ratio of gabor filter
%
%outputs:
%msk - Even orientation convolution mask
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy 2012

%decode inputs
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

msk = 1/(2*pi*sigma_x *sigma_y) * exp(-.5*(x_theta.^2/sigma_x^2+y_theta.^2/sigma_y^2)).*cos(2*pi/lambda*x_theta);
msk = msk-mean(mean(msk));


