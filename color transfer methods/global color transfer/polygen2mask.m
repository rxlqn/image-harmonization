function mask = polygen2mask(poly, nr, nc)

%if iscrowd is 0, the segmentation is in polygen form 
%INPUT: poly: segmentation data 
%       nr: hright
%       nc: width
%OUTPUT: mask: binary mask image
    
len=length(poly);
points=zeros(uint8(len/2),2);
for i=1:len/2
    points(1,i)=poly(2*i-1);
    points(2,i)=poly(2*i);
end
mask=poly2mask(points(1,:),points(2,:),nr,nc);