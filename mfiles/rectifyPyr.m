function newPyr = rectifyPyr(pyr,pol)
%Halfwave rectification of image pyramid
%
%inputs:
%pyr - pyramid to be rectified
%pol - positive or negative rectification
%
%outputs:
%newPyr - rectified pyramid
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2010
newPyr = pyr;
for l = 1:size(pyr,2)
    if isfield(pyr(l),'orientation')
        for ori = 1:size(pyr(l).orientation,2)     
            newPyr(l).orientation(ori).data = (-1)^pol.*newPyr(l).orientation(ori).data;                
            newPyr(l).orientation(ori).data(newPyr(l).orientation(ori).data < 0) = 0;
        end
    else        
        newPyr(l).data = (-1)^pol.*newPyr(l).data;                
        newPyr(l).data(newPyr(l).data < 0) = 0;        
    end
end