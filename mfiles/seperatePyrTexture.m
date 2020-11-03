function [pyr1,pyr2] = seperatePyrTexture(pyr,params,depth)
%Seperates a pyramid into its postive and negative components
%
%Inputs:
%pyr - pyramid structure to seperate
%
%Outputs:
%pyr1 - positive component of pyramid
%pyr2 - negative component of pyramid
%
%Modified by Takeshi Uejima, Johns Hopkins University, 2018-2020
%By Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy ,2010

if nargin ~= 3
    error('Incorrect number of inputs for seperatePyr');
end
n=0;
for l = 1:depth
    for m = l:10
        n=n+1;
        pyr1(n).data = pyr(n).data;
        pyr2(n).data = -pyr(n).data;
        pyr1(n).data(pyr1(n).data < 0 ) = 0;
        pyr2(n).data(pyr2(n).data < 0 ) = 0;
    end
end