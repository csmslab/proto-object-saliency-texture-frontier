function csPyr = csPyramidTexture2(pyr,params,depth,CSsize)
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
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%Proto-object saliency model is originally coded by Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012

if (nargin ~= 4)
    error('Incorrect number of inputs for csPyramid');
end

% depth = params.maxLevel;
csPrs = params.csPrs;
[sigma1,sigma2] = calcSigma(CSsize,3);
%perform centre surround on each level
CSmsk = makeCentreSurround(sigma1,sigma2);
n=0;
for l = 1:depth
    for m = l:10
        n=n+1;
        csPyr(n).data =  validFilt(imresize(pyr(l).data,round(size(pyr(l).data)/(sqrt(2)^(m-l)))),CSmsk);
    end
end