function [h] = runProtoSalTexMax(filename,channels)
%Runs the proto-object based saliency algorithm with Texture Features
%
%inputs:
%filename - filename of image
%channels - channels to use
%               I: Intensity, C: Color, O: Orientation,
%               A: Cross-Scale Energy Texture, B:Cross-Orientation Energy
%               Texture, F: Spatial-Pooling Texture,
%               S: Color Cross-Scale Energy Texture, T: Color
%               Cross-Orientation Energy, V: Color Spatial-Pooling Texture
%               
%By Takeshi Uejima, Johns Hopkins University, 2018-2020
%Proto-object saliency model is originally coded by Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy, 2012

tic
fprintf('Start Proto-Object Saliency')
%generate parameter structure
params = makeDefaultParamsTexture;
pooling=15;
params.tex.maxpooling=pooling;
%Select channels to use
params.channels=channels;
%load and normalize image
im = normalizeImage2(im2double(imread(filename)));
%generate feature channels
img = generateChannelsPyramids(im,params);

%generate border ownership structures
[b1Pyr, b2Pyr]  = makeBorderOwnership2(img,params);
%generate grouping pyramids
gPyr = makeGrouping(b1Pyr,b2Pyr,params);

%normalize grouping pyramids and combine into final saliency map
h = ittiNorm0(gPyr,8,params);

%Save Saliency
imagesc(h.data);colorbar;axis image
[~,name,~]=fileparts(filename)
saveas(gcf,['Result_',name,'.png'])
% saveas(gcf,['Result_',name,'.fig'])
save(['Result_',name,'.mat'],'h');
toc
fprintf('\nDone\n')