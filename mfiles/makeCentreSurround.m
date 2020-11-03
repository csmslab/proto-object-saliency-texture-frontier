function msk = makeCentreSurround(std_center,std_surround)
%Makes the Centre Surround convolution matrix
%inputs:
%   std_center - standard deviation of center
%   std_surround - standard deviation of surround
%
%outputs:
%msk - output convolution mask
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2010

%check inputs
if (nargin ~= 2)
    error('incorrect number of input arguments for makeCentreSurround');
end

%% ------------------------create mask------------------------------------
%mask dimensions
center_dim = ceil(3*std_center);
surround_dim = ceil(3*std_surround);

%create guassians
idx_center = -center_dim:center_dim;
idx_surround = -surround_dim:surround_dim;
msk_center = makeGauss(idx_center,idx_center,std_center,std_center,0);
msk_surround = makeGauss(idx_surround, idx_surround,std_surround,std_surround,0);

%Difference of gaussians
msk = -msk_surround;
msk((surround_dim+1-center_dim):(surround_dim+1+center_dim),(surround_dim+1-center_dim):(surround_dim+1+center_dim)) = msk((surround_dim+1-center_dim):(surround_dim+1+center_dim),(surround_dim+1-center_dim):(surround_dim+1+center_dim))+msk_center;
msk = msk-((sum(sum(msk)))/(size(msk,1)*size(msk,2)));


