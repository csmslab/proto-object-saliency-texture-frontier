function [pyr1,pyr2] = seperatePyr(pyr)
%Seperates a pyramid into its postive and negative components
%
%Inputs:
%pyr - pyramid structure to seperate
%
%Outputs:
%pyr1 - positive component of pyramid
%pyr2 - negative component of pyramid
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins Univeristy ,2010

if nargin ~= 1
    error('Incorrect number of inputs for seperatePyr');
end

if isfield(pyr,'orientation')
   for l = 1:size(pyr,2)
       for ori = 1:size(pyr(l).orientation,2)
           pyr1(l).orientation(ori).data = pyr(l).orientation(ori).data;
           pyr2(l).orientation(ori).data = -pyr(l).orientation(ori).data;
           pyr1(l).orientation(ori).data(pyr1(l).orientation(ori).data<0) = 0;
           pyr2(l).orientation(ori).data(pyr2(l).orientation(ori).data<0) = 0;    
       end
   end   
    
else
   for l = 1:size(pyr,2)
       pyr1(l).data = pyr(l).data;
       pyr2(l).data = -pyr(l).data;
       pyr1(l).data(pyr1(l).data < 0 ) = 0;
       pyr2(l).data(pyr2(l).data <00) = 0;
   end    
end