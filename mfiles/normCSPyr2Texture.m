function [newPyr1 newPyr2] = normCSPyr2Texture(csPyr1, csPyr2, params, depth)
%Normalizes center surround pyramids
%
%inputs:
%   csPyr1 - center surround pyramid 1
%   csPyr2 - center surround pyramid 2
%
%Outputs:
%newPyr1, newPyr2 - normalized cs pyarmids 1 and 2
%
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%Proto-object saliency model is originally coded by Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012
n=0;
% depth=params.maxLevel;
for l = 1:depth
        temp = sumPyrTexture(csPyr1,csPyr2,depth);
        newPyrTmp1(l).data=zeros(size(csPyr1((l-1)*(2*10-(l-1)+1)/2+1).data));
        newPyrTmp2(l).data=newPyrTmp1(l).data;
        for m=l:10
            n=n+1;
            norm = maxNormalizeLocalMax(temp(n).data,[0 10]);
            if max(max(temp(n).data))~=0
                scale = max(max(norm))/max(max(temp(n).data));
            else
                scale = 0;
            end
%             scale=1;
            newPyrTmp1(l).data = newPyrTmp1(l).data + imresize(scale*csPyr1(n).data,size(newPyrTmp1(l).data));
            newPyrTmp2(l).data = newPyrTmp2(l).data + imresize(scale*csPyr2(n).data,size(newPyrTmp2(l).data));
        end
        
        temp = sumPyr(newPyrTmp1,newPyrTmp2);
        norm = maxNormalizeLocalMax(temp(l).data,[0 10]);
        if max(max(temp(l).data))~=0
            scale = max(max(norm))/max(max(temp(l).data));
        else
            scale = 0;
        end
%             scale=1;
        newPyr1(l).data = scale*newPyrTmp1(l).data;
        newPyr2(l).data = scale*newPyrTmp2(l).data;
end