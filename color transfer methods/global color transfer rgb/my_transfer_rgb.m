
dn1_m = 'T:\My_Project\vedio harmonization\Dataset\two\c7c2860db3_seg';
dn1_I = 'T:\My_Project\vedio harmonization\Dataset\two\c7c2860db3';

dn2_m = 'T:\My_Project\vedio harmonization\Dataset\two\fed208bfca_seg';
dn2_I = 'T:\My_Project\vedio harmonization\Dataset\two\fed208bfca';
% CreatVideoFromPic(dn1,'png','bear_mask.avi');
CreatVideoFromPic(dn2_I,'jpg','bear_groundtruth.avi');

M2 = readfullimg_color(dn1_m,'png');
I2 = readfullimg_color(dn1_I,'jpg');

M1 = readfullimg_color(dn2_m,'png');
I1 = readfullimg_color(dn2_I,'jpg');

[m,n,c] = size(I1);

% temp1 = M1(:,:,1,1);
% temp2 = I1(:,:,1);
% 
% temp = (M1(:,:,:,1));
% imshow(uint8(temp));
% figure

aviobj = VideoWriter('test_rgb');
aviobj.FrameRate=12;
temp = M2(:,:,1,1);
open(aviobj);
 M1(M1(:,:,1,:)>1) = 0;
 M2(M2(:,:,1,:)>1) = 0;
 
 
for i = 1:35    %Í¼Æ¬ÕÅÊý
   
    new_im1 = global_color_transfer_rgb(I1(:,:,:,i), I2(:,:,:,i), M1(:,:,1,i), M2(:,:,1,i));
    writeVideo(aviobj,uint8(new_im1));

end
% temp = (M1(:,:,:,1));
% imshow(uint8(temp));
close(aviobj);

