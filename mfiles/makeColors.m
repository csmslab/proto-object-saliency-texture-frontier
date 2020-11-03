function [in,R,G,B,Y] = makeColors(im)
%generates the red green blue and yellow color channels as defined in the
%Itti et al (1998) paper
%
%inputs:
%
%im - input image
%
%outputs:
%
%in - intensity
%R - red 
%G - green
%B - blue
%Y - yellow
%
%By Alexander Russell and Stefan Mihalas, Johns Hopkins University, 2012

fprintf('Generating color channels according to Itti et al (1998)\n');
if size(im,3)==3
    r = im(:,:,1);
    g = im(:,:,2);
    b = im(:,:,3);
    in = (r+g+b)/3;
else
    in = im(:,:);
    r=0;
    g=0;
    b=0;
end
msk = in;
msk(msk<0.1*max(max(in)))=0;
msk(msk~=0)=1;
r=safeDivide(r.*msk,in);
g=safeDivide(g.*msk,in);
b=safeDivide(b.*msk,in);

R = r-(g+b)./2;
R(R<0) = 0;

G = g-(r+b)./2;
G(G<0) = 0;

B = b-(r+g)./2;
B(B<0) = 0;
Y = (r+g)./2-abs(r-g)./2-b;
Y(Y<0) = 0;

