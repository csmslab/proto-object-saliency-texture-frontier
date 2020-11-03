function [gPyr1 gPyr2] = groupingPyramidMaxDiff(bPyr1,bPyr2,params)
%Calculates grouping activity from border ownership activity
%
%Inputs:
%bPyr1 - border ownership pyramid 1 from von Mises Msk1
%bPyr2 - border ownership pyramid 2 from von Mises Msk2
%params - parameter structure
%
%Outputs:
%gPyr1 - grouping pyramid constructed from von Mises Msk1
%gPyr2 - grouping pyramid constructed from von Mises Msk2
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2011

if (nargin ~= 3)
    error('Incorrect number of arguments for groupingPyramid');
end
if (nargout ~= 2)
    error('Two output arguments are needed for groupingPyramid');
end
bPrs = params.bPrs;

giPrs = params.giPrs;
w = giPrs.w_sameChannel;

%calculate border ownership and grouping responses

for l = bPrs.minLevel:bPrs.maxLevel
    
    clear bTemp1;
    clear bTemp2;
    clear bTemp3;
    clear bTemp4;
    for ori = 1:bPrs.numOri
        bTemp1(ori,:,:) = abs(bPyr1(l).orientation(ori).data-bPyr2(l).orientation(ori).data);
    end
    [m1 m_ind1] = max(bTemp1,[],1);
    
    
    for ori = 1:bPrs.numOri
        m_i1 = squeeze(m_ind1);
        m_i1(m_i1 ~= ori) = 0;
        m_i1(m_i1 == ori) = 1;
        
        invmsk1 = bPyr1(l).orientation(ori).invmsk;
        invmsk2 = bPyr2(l).orientation(ori).invmsk;
        
        b1p = m_i1.*(bPyr1(l).orientation(ori).data-bPyr2(l).orientation(ori).data);
        b1n = -b1p;
        b1p(b1p<0) = 0;
        b1p(b1p ~= 0) = 1;
        b1n(b1n<0) = 0;
        b1n(b1n~=0) = 1;
        
        gPyr1(l).orientation(ori).data = validFilt(b1p.*bPyr1(l).orientation(ori).data,invmsk1)-validFilt_grp(w.*b1p.*bPyr2(l).orientation(ori).data,invmsk1);
        gPyr2(l).orientation(ori).data = validFilt(b1n.*bPyr2(l).orientation(ori).data,invmsk2)-validFilt_grp(w.*b1n.*bPyr1(l).orientation(ori).data,invmsk2);
        
        gPyr1(l).orientation(ori).data(gPyr1(l).orientation(ori).data<0) = 0;
        gPyr2(l).orientation(ori).data(gPyr2(l).orientation(ori).data<0) = 0;
    end
end

