function newMap = validFilt_grp(map,msk,type)
%performs a valid correlation/convolution of map and msk. The result is
%zero padded to the same size as map once the filtering as been performed

newMap = imfilter(map,msk,'replicate',max(max(map)));