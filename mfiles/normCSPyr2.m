function [newPyr1 newPyr2] = normCSPyr(csPyr1, csPyr2)
%Normalizes center surround pyramids
%
%inputs:
%   csPyr1 - center surround pyramid 1
%   csPyr2 - center surround pyramid 2
%
%Outputs:
%newPyr1, newPyr2 - normalized cs pyarmids 1 and 2
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

for l = 1:size(csPyr1,2)
        temp = sumPyr(csPyr1,csPyr2);
        norm = maxNormalizeLocalMax(temp(l).data,[0 10]);
        if max(max(temp(l).data))~=0
            scale = max(max(norm))/max(max(temp(l).data));
        else
            scale = 0;
        end
        newPyr1(l).data = scale*csPyr1(l).data;
        newPyr2(l).data = scale*csPyr2(l).data;
end