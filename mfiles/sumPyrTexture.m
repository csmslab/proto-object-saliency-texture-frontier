function pyr = sumPyrTexture(pyr1,pyr2,depth)
%Sums the levels of two input pyramids. It can handle the following pyramid
%structures pyr.data, pyr.orientation.data and pyr.hData/pyr.vData
%
%Inputs:
%
%   pyr1 - pyramid 1
%   pyr2 - pyramid 2
%
%Outputs;
%
%   pyr - pyramid 1 + pyramid 2
%
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2011

if (nargin ~= 3)
    error('sumPyr needs 3 input arguments');
end
if isempty(pyr1)
    pyr = pyr2;
else
    if size(pyr1,2) ~= size(pyr2,2)
        error('Input pyramids different sizes');
    end
    n=0;
    for l = 1:depth
        for m=l:10
            n=n+1;
            pyr(n).data = pyr1(n).data+pyr2(n).data;
        end
    end
end