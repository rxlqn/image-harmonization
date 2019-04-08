function [final_im1_0,final_im1_1,final_im1_2] = global_color_transfer(img_tgt, img_ref, mask_tgt, mask_ref)

%get the segmented object in target iamge and reference image
im1=(uint8(img_tgt).*uint8(mask_tgt));
im2=(uint8(img_ref).*uint8(mask_ref));
% figure,imshow(im1);
% figure,imshow(im2);

% project images into lab space
[nr1,nc1,nd1] = size(im1);
if nd1==1
    new1=zeros(nr1,nc1,3);
    for i=1:3
        new1(:,:,i)=im1;
    end
    im1=new1;
end
im1 = reshape(double(im1), nr1*nc1, 3);
im1_rgb = im1/255;  % convert rgb values to [0,1] range
im1_lab = rgb2lab(im1_rgb);
im1_ciecam = rgb2ciecam(im1_rgb);

[nr2,nc2,nd2] = size(im2);
if nd2==1
    new2=zeros(nr2,nc2,3);
    for i=1:3
        new2(:,:,i)=im2;
    end
    im2=new2;
end
im2 = reshape(double(im2), nr2*nc2, 3);
im2_rgb = im2/255;  % convert rgb values to [0,1] range
im2_lab = rgb2lab(im2_rgb);
im2_ciecam = rgb2ciecam(im2_rgb);

% mean-std conversion
%new_im1_rgb = rescale_image(im1_rgb, im2_rgb);
new_im1_rgb = rescale_image(im1, im2);
new_im1_lab = rescale_image(im1_lab, im2_lab);
new_im1_ciecam = rescale_image(im1_ciecam, im2_ciecam);

% convert back into rgb space
%new_im1_0 = reshape(uint8(new_im1_rgb*255), nr1,nc1,nd1);
new_im1_0 = reshape(uint8(new_im1_rgb), nr1,nc1,3);
new_im1_1 = lab2rgb(new_im1_lab);
new_im1_1 = reshape(uint8(new_im1_1*255), nr1,nc1,3);
new_im1_2 = ciecam2rgb(new_im1_ciecam);
new_im1_2 = reshape(uint8(new_im1_2*255), nr1,nc1,3);

%get the background mask
bgm=uint8(fg2bg_mask(mask_tgt));

%final image = color-transfered foreground and original background
final_im1_0=new_im1_0+(img_tgt.*bgm);
final_im1_1=new_im1_1+(img_tgt.*bgm);
final_im1_2=new_im1_2+(img_tgt.*bgm);