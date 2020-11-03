function msk = makeGauss(dim1,dim2,sigma_1,sigma_2,theta,x0,y0,norm)
%Returns a 2D gaussian mask. Axes are defined accoringd to
%        /
%       /theta
%       ----------- x
%      |
%      |
%      |
%      | 
%      y
%
%inputs:
%dim1 - vector of points over which to compute gaussian in dimension 1
%dim2 - vector of points over whcih to compute gaussian in dimension 2
%std1 - standard deviation in dimension 1
%std2 - standard deviation in dimension 2
%theta - angle of rotation (if no input assumed 0)
%x0 - offset in dimention 1 (if no input assumed 0)
%y0 - offset in dimention 2 (if no input assumed 0)
%norm - 1 - normalize gaussian, 0 - don't normalize (assumed 1)
%
%outputs:
%msk - size(dim1) x size(dim2) matrix of gaussian
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2010

%check inputs
if (nargin < 4) || (nargin > 8)
    error('Incorrect number of inputs for makeGauss');
elseif (nargin == 4)
    theta = 0;
    x0 = 0;
    y0 = 0;
elseif (nargin == 5)
    x0 = 0;
    y0 = 0;
elseif (nargin == 6)
    error('Both dimension 1 and dimension 2 offsets must be specified');
end
if nargin ~= 8 %normalize Gaussian
    norm =1;
end
    
msk = zeros(size(dim1,2),size(dim2,2));
[X,Y] = meshgrid(dim1,dim2);
a = cos(theta)^2/2/sigma_1^2 + sin(theta)^2/2/sigma_2^2;
b = -sin(2*theta)/4/sigma_1^2 + sin(2*theta)/4/sigma_2^2 ;
c = sin(theta)^2/2/sigma_1^2 + cos(theta)^2/2/sigma_2^2;

if norm
    msk = 1/(2*pi*sigma_1*sigma_2)* exp( - (a*(X-x0).^2 + 2*b*(X-x0).*(Y-y0) + c*(Y-y0).^2));
else
    msk = exp( - (a*(X-x0).^2 + 2*b*(X-x0).*(Y-y0) + c*(Y-y0).^2));
end
