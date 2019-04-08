function bgm = fg2bg_mask(mask)

%convert foregraound mask to background mask

[nr,nc,nd]=size(mask);
bgm=zeros(nr,nc);
for i=1:nr
    for j=1:nc
        if mask(i,j)==0
            bgm(i,j)=1;
        end
    end
end
