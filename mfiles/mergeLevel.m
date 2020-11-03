function newPyr = mergeLevel(pyr)
%merges pyramid orientations at each level. 
%
%inputs:
%pyr - pyramid to be merged
%
%outputs:
%newPyr - merged pyramid
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2011

if nargin ~= 1
    error('mergeLevel requires one input argument');
end

for l = 1:size(pyr,2)
    if isfield(pyr,'orientation')
        temp = zeros(size(pyr(l).orientation(1).data));
        for ori = 1:size(pyr(l).orientation,2)     
            temp = temp + pyr(l).orientation(ori).data;
        end
        newPyr(l).data = temp;
    end
end