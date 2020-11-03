function gaborPyr = gaborPyramid(pyr,ori,params)
%Filters input image pyramid with a gabor filter at angle ori
%
%inputs :
%pyr - scale pyramid
%ori - orientation of gabor filter
%params - model parameter structure
%
%outputs :
%gaborPyr - filtered gabor pyramid
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

if (nargin ~= 3)
    error('Incorrect number of inputs for gaborPyramid');
end
if (nargout ~= 1)
    error('One output argument required for gaborPyramid');
end

depth = params.maxLevel;
gaborPrs = params.gaborPrs;

%make even gabor filter kernel
Evmsk =  makeEvenOrientationCells(ori,gaborPrs.lamba,gaborPrs.sigma,gaborPrs.gamma);
%filter image pyramid
for l = 1:depth
    gaborPyr(l).data =  validFilt(pyr(l).data,Evmsk); 
    %02/11/2018
%     gaborPyr(l).data =  validFiltCirc(pyr(l).data,Evmsk);
    gaborPyr(l).msk =  Evmsk;%TU msk added 11/6/2017
end

