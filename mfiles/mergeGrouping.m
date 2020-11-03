function [h h_norm h_channels] = mergeGrouping(gPyr,params)
%merges grouping pyramids and performs normalization
%
%Inputs:
%   gPyr - grouping pyramids
%   params - parameters
%
%Outputs:
%   h_norm - final saliency map normalized
%   h - final saliency map
%   h - individual saliency maps of each feature channel

h_norm.data = zeros(256, 256);
h.data = zeros(256, 256);
for i = 1:size(gPyr,2)
    gm_Norm(i,:,:) = mergePyrLocalMax(gPyr{i},params);
    h_channels{i}.h_norm.data = squeeze(gm_Norm(i,:,:));
    h_norm.data = h_norm.data+maxNormalizeLocalMax(squeeze(gm_Norm(i,:,:)));
    h_norm.type = 'Local Maximum at every level';
    gm(i,:,:) = mergePyr(gPyr{i},params);
    h.data = h.data+maxNormalizeLocalMax(squeeze(gm(i,:,:)));
    h.type = 'Local Maximum only applied to merged pyramid';
    h_channels{i}.h.data = squeeze(gm(i,:,:));
end