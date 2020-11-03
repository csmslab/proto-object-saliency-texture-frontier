function [map1 msk1 map2 msk2] = vonMisesSum(csPyr,vmPrs)
%Convolves the center surround maps with the Von Mises masks and summates
%over different pyramid levels
%
%inputs
%csPyr - center surround pyramid
%vmPrs - von Mises distribution parameters
%
%outputs:
%map1 - output of summation using von Mises msk1
%msk1 - von Mises distribution
%map2 -  output of summation using von Mises msk2 (msk1 rotated through 180 degrees)
%msk2 - von Mises distribution
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012


if (nargin~=2)
    error('vonMisesSum requires 2  inputs');
end

maxLevel = vmPrs.maxLevel;

%create pyramid of Center Surround convolved with von Mises distribution
% [vmPyr1 msk1 vmPyr2 msk2] = vonMisesPyramid(csPyr,vmPrs);
[vmPyr1 msk1 vmPyr2 msk2] = vonMisesPyramid(csPyr,vmPrs); %TU Normal ,Rand or Symmetric filter 
map.orientation(1).data = [];
map.orientation(vmPrs.numOri).data = [];
map1 = repmat(map,1,maxLevel);
map2 = repmat(map,1,maxLevel);

%sum convolved output across different spatial scales
for minL = 1:maxLevel
    mapLevel = minL;
    for l = minL:maxLevel
        for ori = 1:vmPrs.numOri
            if l == minL
                map1(minL).orientation(ori).data = zeros(size(vmPyr1(mapLevel).orientation(ori).data));
                map2(minL).orientation(ori).data = zeros(size(vmPyr2(mapLevel).orientation(ori).data));
            end     
            map1(minL).orientation(ori).data = map1(minL).orientation(ori).data + (0.5^(l-1)).*imresize(vmPyr1(l).orientation(ori).data,size(vmPyr1(mapLevel).orientation(ori).data),'nearest');
            map2(minL).orientation(ori).data = map2(minL).orientation(ori).data + (0.5^(l-1)).*imresize(vmPyr2(l).orientation(ori).data,size(vmPyr1(mapLevel).orientation(ori).data),'nearest');
        end
    end
end
