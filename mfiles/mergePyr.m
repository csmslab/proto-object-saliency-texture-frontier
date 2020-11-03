function im = mergePyr(pyr,params)
%this function merges the different levels of a pyramid into a single image
%
%inputs:
%pyr - image pyramid to be merged
%
%outputs:
%im - image from merged pyramid
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2010

if isfield(pyr,'orientation')
    im = zeros(size(pyr(1).orientation(1).data));
else
    im = zeros(size(pyr(1).data));
end
gPrs = params.gPrs;
a = gPrs.collapseW_power;
b = gPrs.collapseW_mult;

for l = 1:size(pyr,2)
    if isfield(pyr,'orientation')
        temp = zeros(size(pyr(l).orientation(1).data));
        for ori = 1:size(pyr(l).orientation,2)     
            temp = temp + pyr(l).orientation(ori).data;
        end
        if strcmp(params.downSample,'half')%downsample halfoctave
            im = im +  (b.*sqrt(2)^(l-1))^a.*imresize(temp,size(im));
        elseif strcmp(params.downSample,'full') %downsample full octave
            im = im +  (b.*2^l)^a.*imresize(temp,size(im));
        else
            error('Please specify if downsampling should be half or full octave');
        end
        
    else   
        if strcmp(params.downSample,'half')%downsample halfoctave
            im = im +  b.*l^a.*imresize(pyr(l).data,params.imSize);
        elseif strcmp(params.downSample,'full') %downsample full octave
            im = im +  b.*l^a.*imresize(pyr(l).data,2^(l-1));
        else
            error('Please specify if downsampling should be half or full octave');
        end
%         im = im + imresize(pyr(l).data,2^(l-1));
        
    end
end