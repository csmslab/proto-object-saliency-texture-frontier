function csPyr = csPyramidTexture(pyr,params)
%Makes the centre surround pyramid using a CS mask on each
%layer of the image pyramid
%
%inputs :
%pyr - scale pyramid
%params - model parameter structure
%
%outputs :
%csPyr - outputted centre surround pyramid structure
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

if (nargin ~= 2)
    error('Incorrect number of inputs for csPyramid');
end
if (nargout ~= 1)
    error('One output argument required for csPyramid');
end

depth = params.maxLevel;
csPrs = params.csPrs;
%perform centre surround on each level
CSmsk = makeCentreSurround(csPrs.inner,csPrs.outer);
n=0;
for l = 1:depth
    for m = l:depth
        n=n+1;
        csPyr(n).data =  validFilt(imresize(pyr(l).data,size(pyr(m).data)),CSmsk);
    end
end