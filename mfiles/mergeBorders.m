function newbPyr = mergeBorders(bPyr)
%Combines border ownership vectors across all orientations
%
%inputs:
%bPyr - border ownership pyramid with borders for each orientation
%
%outputs:
%newbPyr - border ownership pyramid with one border map per level
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2011

for l = 1:size(bPyr,2)
    newbPyr(l).hData = zeros(size(bPyr(l).orientation(1).hData));
    newbPyr(l).vData = zeros(size(bPyr(l).orientation(1).vData));
    for ori = 1:size(bPyr(l).orientation,2)
        newbPyr(l).hData = newbPyr(l).hData + bPyr(l).orientation(ori).hData;
        newbPyr(l).vData = newbPyr(l).vData + bPyr(l).orientation(ori).vData;        
    end
end