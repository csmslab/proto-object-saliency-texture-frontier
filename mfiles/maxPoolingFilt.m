function [output] = maxPoolingFilt(img,diameter)

if mod(diameter,2)==0
    error('Diameter should be an odd number')
end
[sizeY,sizeX]=size(img);
% if sizeY<diameter || sizeX<diameter
%     error('Image size should be larger than diameter')
% end
%Make Circular Mask
center=(diameter+1)/2;
radius=(diameter-1)/2;
[xx,yy] = meshgrid(1:diameter,1:diameter);
mask = false(diameter);     %Logical 0 of diameter x diameter 
mask = mask | hypot(xx - center, yy - center) <= radius;

imgBig=zeros(sizeY+radius*2,sizeX+radius*2);
imgBig(radius+1:sizeY+radius,radius+1:sizeX+radius)=img;
output=zeros(sizeY,sizeX);
%Apply Mask
for ii=radius+1:sizeY+radius  %without border of image
    for jj=radius+1:sizeX+radius
        patch=imgBig(ii-radius:ii+radius,jj-radius:jj+radius);
        maxValue=max(max(patch.*mask));
        output(ii-radius,jj-radius)=maxValue;
    end
end

end

