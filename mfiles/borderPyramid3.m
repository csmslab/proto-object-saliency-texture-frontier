function [bPyr1 bPyr2 bPyr3 bPyr4] = borderPyramid3(csPyrL,csPyrD,cPyr,params)
%Creates component border ownershp and grouping pyramids using odd edge cells
%This is a boundary effect corrected version
%
%inputs:
%csPyrL - Center Surround Pyramid,  excitatory center
%csPyrD - Center Surround Pyramid, inhibitory center
%cPyr - complex edge Pyramid
%params - algroithm parameter structure
%
%outputs:
%bPyr1 - Border ownership pyramid from csPyrL and von Mises msk1
%bPyr2 - Border ownership pyramid from csPyrL and von Mises msk2
%bPyr3 - Border ownership pyramid from csPyrD and von Mises msk1
%bPyr4 - Border ownership pyramid from csPyrD and von Mises msk2
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012
%Modified by Takeshi Uejima, Johns Hopkins University, 2018

if (nargin ~= 4)
    error('Incorrect number of arguments for borderPyramid');
end
if (nargout ~= 4)
    error('Four output arguments are needed for borderPyramid');
end
bPrs = params.bPrs;
vmPrs = params.vmPrs;

%Convolve Center Surround with von Mises distribution and, for every
%orientation, sum across all spatial scales greater or equal to scale l
[vmL1 msk1 vmL2 msk2] = vonMisesSum(csPyrL,vmPrs);
[vmD1 csmsk1 vmD2 csmsk2] = vonMisesSum(csPyrD,vmPrs);
[vmL1P msk1P vmL2P msk2P] = vonMisesSumPlus(csPyrL,vmPrs);
[vmD1P csmsk1P vmD2P csmsk2P] = vonMisesSumPlus(csPyrD,vmPrs);

%calculate border ownership and grouping responses
for l = bPrs.minLevel:bPrs.maxLevel        
    for  ori = 1:bPrs.numOri   
        %create border ownership for light objects (on center CS results)
        bPyr1(l).orientation(ori).data = cPyr(l).orientation(ori).data .* (1+bPrs.alpha.*(vmL1(l).orientation(ori).data-bPrs.CSw.*vmD2P(l).orientation(ori).data));%csVm2(l)
        bPyr1(l).orientation(ori).data(bPyr1(l).orientation(ori).data<0) = 0;
        bPyr1(l).orientation(ori).ori = msk1(l).orientation(ori).ori;
        
        bPyr2(l).orientation(ori).data = cPyr(l).orientation(ori).data .* (1+bPrs.alpha.*(vmL2(l).orientation(ori).data-bPrs.CSw.*vmD1P(l).orientation(ori).data));%csVm1(l)
        bPyr2(l).orientation(ori).data(bPyr2(l).orientation(ori).data<0) = 0;        
        bPyr2(l).orientation(ori).ori = msk2(l).orientation(ori).ori+pi;
        
        bPyr1(l).orientation(ori).invmsk = msk1(l).orientation(ori).data; 
        bPyr2(l).orientation(ori).invmsk = msk2(l).orientation(ori).data;   
        
        %create border ownership for dark objects (off center cs results)
        bPyr3(l).orientation(ori).data = cPyr(l).orientation(ori).data .* (1+bPrs.alpha.*(vmD1(l).orientation(ori).data-bPrs.CSw.*vmL2P(l).orientation(ori).data));%csVm2(l)
        bPyr3(l).orientation(ori).data(bPyr3(l).orientation(ori).data<0) = 0;
        bPyr3(l).orientation(ori).ori = msk1(l).orientation(ori).ori;
        bPyr4(l).orientation(ori).data = cPyr(l).orientation(ori).data .* (1+bPrs.alpha.*(vmD2(l).orientation(ori).data-bPrs.CSw.*vmL1P(l).orientation(ori).data));%csVm1(l)
        bPyr4(l).orientation(ori).data(bPyr4(l).orientation(ori).data<0) = 0;        
        bPyr4(l).orientation(ori).ori = msk2(l).orientation(ori).ori+pi;
        
        bPyr3(l).orientation(ori).invmsk = msk1(l).orientation(ori).data; 
        bPyr4(l).orientation(ori).invmsk = msk2(l).orientation(ori).data;
    end
end