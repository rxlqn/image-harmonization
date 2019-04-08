function mask = rle2mask(rle, nr, nc)

%if iscrowd is 1, the segmentation is in RLE form 
%INPUT: rle: segmentation data 
%       nr: hright
%       nc: width
%OUTPUT: mask: binary mask image

all=nr*nc;
mask=zeros(1,all);
N=length(rle);
n=1;
val=1;
for i=1:N
    val= 1-val;
    for j=1:rle(i)
        mask(n)=val;
        n=n+1;
    end
end
mask=reshape(mask,nr,nc);
%figure,imshow(mask);
    