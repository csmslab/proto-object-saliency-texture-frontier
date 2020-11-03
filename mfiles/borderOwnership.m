function bPyr = borderOwnership(bPyr1,bPyr2)
%Unifies the two border ownership pyramids from von Mises msks 1 and 2 into
%a single pyramid
%
%inputs:
%bPyr1 - border owneship pyramid 1 using von Mises msk1
%bPyr2 - border ownership pyramid made using von Mises msk2
%
%outputs:
%bPyr - unified border ownership pyramid
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2010

b1 = decomposeBorders(bPyr1);
b2 = decomposeBorders(bPyr2);
for l = 1:size(bPyr1,2)
    for ori = 1:size(bPyr1(l).orientation,2)
        bPyr(l).orientation(ori).hData = b2(l).orientation(ori).hData+b1(l).orientation(ori).hData;
        bPyr(l).orientation(ori).vData = b2(l).orientation(ori).vData+b1(l).orientation(ori).vData;
    end
end
