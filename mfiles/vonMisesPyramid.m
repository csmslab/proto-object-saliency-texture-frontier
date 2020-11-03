function [pyr1 msk1 pyr2 msk2] = vonMisesPyramid(map, vmPrs)
%Convolves input pyramid with von Mises distribution
%
%inputs:
%map - pyramid structure on which to apply von Mises filter
%vmPrs - parameters for von Mises filter
%
%outputs:
%pyr1 - filtered pyramid using msk1
%msk1 - first von mises mask at all scales and orientations
%pyr2 - filtered pyramid using msk2
%msk2 - second von mises mask at all scales and orientations
%
%by Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012



for ori = 1:vmPrs.numOri
    for l = vmPrs.minLevel:vmPrs.maxLevel
        dim1 = -3*vmPrs.R0:3*vmPrs.R0;
        dim2 = dim1;
        if ~(isempty(map(l)))
            [msk_1,msk_2] =  makeVonMises(vmPrs.R0, vmPrs.oris(ori)+pi/2,dim1,dim2);
            
            pyr1(l).orientation(ori).data = imfilter(map(l).data,msk_1,0);
            msk1(l).orientation(ori).data = msk_2;
            pyr1(l).orientation(ori).ori = vmPrs.oris(ori)+pi/2;
            msk1(l).orientation(ori).ori = vmPrs.oris(ori)+pi/2;
            
            pyr2(l).orientation(ori).data = imfilter(map(l).data,msk_2,0);
            msk2(l).orientation(ori).data = msk_1;
            pyr2(l).orientation(ori).ori = vmPrs.oris(ori)+pi/2;
            msk2(l).orientation(ori).ori = vmPrs.oris(ori)+pi/2;
        else
            error('Map is empty at specifed level');
        end
    end
end