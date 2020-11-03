function pyr = sumPyr(pyr1,pyr2)
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
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2011

if (nargin ~= 2)
    error('sumPyr needs two input arguments');
end
if isempty(pyr1)
    pyr = pyr2;
else
    if size(pyr1,2) ~= size(pyr2,2)
        error('Input pyramids different sizes');
    end
    if isfield(pyr1,'orientation')
        for l = 1:size(pyr1,2)
            for ori = 1:size(pyr1(l).orientation,2)
                pyr(l).orientation(ori).data = pyr1(l).orientation(ori).data+pyr2(l).orientation(ori).data;
                if isfield(pyr1(l).orientation,'ori')
                    pyr(l).orientation(ori).ori = pyr1(l).orientation(ori).ori;
                    if isfield(pyr1(l).orientation,'invmsk')
                        pyr(l).orientation(ori).invmsk = pyr1(l).orientation(ori).invmsk;
                    end
                end
                
            end
        end
    elseif isfield(pyr1,'data')
        for l = 1:size(pyr1,2)
            pyr(l).data = pyr1(l).data+pyr2(l).data;
        end
    elseif isfield(pyr1,'hData')
        for l = 1:size(pyr1,2)
            pyr(l).hData = pyr1(l).hData+pyr2(l).hData;
            pyr(l).vData = pyr1(l).vData+pyr2(l).vData;
        end
    end
end