
dn1_m = 'T:\My_Project\vedio harmonization\Dataset\gygo-dataset\Annotations\480p\batch-00002\cool-car-gray';
dn1_I = 'T:\My_Project\vedio harmonization\Dataset\gygo-dataset\JPEGImages\480p\batch-00002\cool-car-gray';

dn2_m = 'T:\My_Project\vedio harmonization\Dataset\gygo-dataset\Annotations\480p\batch-00002\cool-car-red';
dn2_I = 'T:\My_Project\vedio harmonization\Dataset\gygo-dataset\JPEGImages\480p\batch-00002\cool-car-red';
% CreatVideoFromPic(dn1,'png','bear_mask.avi');
% CreatVideoFromPic(dn2_I,'jpg','bear_groundtruth.avi');

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

temp = M2(:,:,1,1);
%  M1(M1(:,:,1,:)>1) = 0;
%  M2(M2(:,:,1,:)>1) = 0;
 
 
for i = 1:1    %Í¼Æ¬ÕÅÊý
   
    new_im1 = global_color_transfer_rgb(I1(:,:,:,i), I2(:,:,:,i), M1(:,:,1,i)/255, M2(:,:,1,i)/255);
%     imshow(new_im1);

end


