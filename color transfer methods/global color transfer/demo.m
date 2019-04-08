function demo()
%80 COCO categories [10,8]
%person, bicycle, car, motorcycle, airplane, bus, train, truck, boat, traffic light,
%fire hydrant, stop sign, parking meter, bench, bird, cat, dog, horse, sheep, cow,
%elephant, bear, zebra, giraffe, backpack, umbrella, handbag, tie, suitcase, frisbee,
%skis, snowboard, sports ball, kite, baseball bat, baseball glove, skateboard, surfboard, tennis racket, bottle,
%wine glass, cup, fork, knife, spoon, bowl, banana, apple, sandwich, orange,
%broccoli, carrot, hot dog, pizza, donut, cake, chair, couch, potted plant, bed,
%dining table, toilet, tv, laptop, mouse, remote, keyboard, cell phone, microwave, oven,
%toaster, sink, refrigerator, book, clock, vase, scissors, teddy bear, hair drier, toothbrush,

clear; close all;
dbstop if error

dataTypes={'train2014','train2017','val2014','val2017'};
numForEachCat={95,130,50,8}; %personal setting, related to how many results you want

for TypeIndex=1:4 
    dataType=dataTypes{TypeIndex};
    
    for catId=1:80
        %get ids of images containing designated kind of object
        annFile=sprintf('../annotations/instances_%s.json',dataType);
        coco=CocoApi(annFile);
        catIds = coco.getCatIds('catIds',catId);
        if catIds>0
            cat = coco.loadCats(catId);
            imgIds = coco.getImgIds('catIds',catId);
        else
            continue;
        end
%         %check the categories
%         cat = coco.loadCats(catId);
%         fprintf('category name: %s\n', cat.name);
        
        len=length(imgIds);

        n=1;
        for idx=1:len
            imgId1=imgIds(idx);
            img1 = coco.loadImgs(imgId1);
            nr=img1.width;
            nc=img1.height;
            anns1 = coco.loadAnns(coco.getAnnIds('imgIds',imgId1));
            len1=length(anns1);
            
            max_area1=0; show1=1;
            for i=1:len1
                if anns1(i).category_id==catId && anns1(i).area>max_area1
                    max_area1=anns1(i).area;
                    show1=i;
                end
            end
            if max_area1<0.05*nr*nc
                continue;
            end
            % reminder contains image ids with object larger than 5% of the image size
            reminder(n)=imgId1; 
            n=n+1;
        end
        if n-1==1
            continue;
        end
        
        for iterate=1:numForEachCat{TypeIndex}
%             imgId1 = 297353; %from val2017 has several segmentation parts of a person
%             imgId2 = 261318; %from val2017 has several segmentation parts of a person
%             imgId1 = 137281;
%             imgId2 = 75052; %from val2017 640*444 uint8, a gray image

            %select 2 images randomly, which contain the same kind of object
            imgId1 = reminder(randi(n-1));
            imgId2 = reminder(randi(n-1));
            fprintf('imgID1: %d\n',imgId1);
            fprintf('imgID2: %d\n',imgId2);
            
            %load source and reference images
            img1 = coco.loadImgs(imgId1);
            I1 = imread(sprintf('../images/%s/%s',dataType,img1.file_name));
            img2 = coco.loadImgs(imgId2);
            I2 = imread(sprintf('../images/%s/%s',dataType,img2.file_name));
            %show image
%             figure(1), subplot(1,2,1), imshow(I1), title('source');
%             subplot(1,2,2), imshow(I2), title('reference');
            
            %save ground truth images
            filepath=pwd;
            cd(sprintf('E:\\coco\\composite_images\\%s_gct\\groundtruth',dataType));
            imwrite(I1,sprintf('%s_%g_gct_truth.jpg',dataType,imgId1));
            cd(filepath);
            
            %load annotations for source image
            %select the largest segmented instance of that kind of object
            annIds1 = coco.getAnnIds('imgIds',imgId1);
            anns1 = coco.loadAnns(annIds1);
            len1=length(anns1);
            max_area1=0; show1=1;
            for i=1:len1
                if anns1(i).category_id==catId && anns1(i).area>max_area1
                    max_area1=anns1(i).area;
                    show1=i;
                end
            end
            % show and check
%             subplot(1,2,1),coco.showAnns(anns1);
            
            %generate mask for source image
            [nr1,nc1,nd1]=size(I1);
            if anns1(show1).iscrowd==0
                %use polygon annotation
                polynum1=length(anns1(show1).segmentation);
                bm1=zeros(nr1,nc1);
                for i=1:polynum1
                    poly=anns1(show1).segmentation{1,i};
                    bm1=bm1+polygen2mask(poly,nr1,nc1);
                end
            else
                %use rle annotation
                rle=anns1(show1).segmentation.counts;
                bm1=rle2mask(rle,nr1,nc1);
            end
            
            %save mask of source image
            filepath=pwd;
            cd(sprintf('E:\\coco\\composite_images\\%s_gct\\mask',dataType));
            imwrite(bm1,sprintf('%s_%g_gct_mask.jpg',dataType,imgId1));
            cd(filepath);
            
            
            %load annotations for reference image
            %select the largest segmented instance of that kind of object
            annIds2 = coco.getAnnIds('imgIds',imgId2);
            anns2 = coco.loadAnns(annIds2);
            len2=length(anns2);
            max_area2=0; show2=1;
            for i=1:len2
                if anns2(i).category_id==catId && anns2(i).area>max_area2
                    max_area2=anns2(i).area;
                    show2=i;
                end
            end
            %show and check
%             subplot(1,2,2),coco.showAnns(anns2);
            
            %mask for reference image
            [nr2,nc2,nd2]=size(I2);
            if anns2(show2).iscrowd==0
                polynum2=length(anns2(show2).segmentation);
                bm2=zeros(nr2,nc2);
                for i=1:polynum2
                    poly=anns2(show2).segmentation{1,i};
                    bm2=bm2+polygen2mask(poly,nr2,nc2);
                end
            else
                rle=anns2(show2).segmentation.counts;
                bm2=rle2mask(rle,nr2,nc2);
            end
            
%% global color transfer
            [final_im1_0,final_im1_1,final_im1_2] = global_color_transfer(I1, I2,bm1, bm2);
            
            %save images
            filepath=pwd;
            cd(sprintf('E:\\coco\\composite_images\\%s_gct\\composite',dataType));
            %imwrite(final_im1_0,sprintf('%s_gct_%s_%g_%g_rgb.jpg',dataType,cat.name,imgId1,imgId2));
            imwrite(final_im1_1,sprintf('%s_%g_gct_%g.jpg',dataType,imgId1,imgId2));
            %imwrite(final_im1_2,sprintf('%s_gct_%s_%g_%g_ciecam97.jpg',dataType,cat.name,imgId1,imgId2));
            cd(filepath);
            
%             % show results
%             figure, subplot(1,3,1),imshow(final_im1_0), title('converted image - RGB');
%             subplot(1,3,2),imshow(final_im1_1), title('converted image - LAB');
%             subplot(1,3,3),imshow(final_im1_2), title('converted image - CIECAM97');


%% global color transfer in correlated color space
%             final_im1_0 = global_color_transfer_rgb(I1, I2, bm1, bm2);
%             
%             % save image
%             filepath=pwd;
%             cd(sprintf('E:\\coco\\composite_images\\%s_gctRGB\\composite',dataType));
%             imwrite(final_im1_0,sprintf('%s_%g_gctRGB_%g.jpg',dataType,imgId1,imgId2)); 
%             cd(filepath);
%             
% %             % show result
% %             figure, imshow(final_im1_0),title('converted image - RGB');
%% MKL and IDT-regrain color transfer
%         % image and mask applied
%         im1=(uint8(I1).*uint8(bm1));
%         im2=(uint8(I2).*uint8(bm2));
%         
%         img_tgt=double(im1)/255;
%         img_ref=double(im2)/255;
%         IR_mkl = colour_transfer_MKL(img_tgt,img_ref);
%         %rng(0);
%         IR_idt = colour_transfer_IDT(img_tgt,img_ref,10);
%         IR_idt_regrain = regrain(img_tgt,IR_idt); %IRR = degrain(I_original, I_graded, [smoothness]); smoothness (default=1, smoothness>=0)
%         
%         %reduce the noise in matting
%         IR_mkl=uint8(IR_mkl*255).*uint8(bm1);
%         %IR_idt=uint8(IR_idt*255).*uint8(bm1);
%         IR_idt_regrain=uint8(IR_idt_regrain*255).*uint8(bm1);
%         
%         %background mask of target image
%         bgm=uint8(fg2bg_mask(bm1));        
%         background=uint8(I1).*bgm;
%         
%         %final images
%         final_IR_mkl=uint8(IR_mkl)+background;
%         %final_IR_idt=uint8(IR_idt)+background;
%         final_IR_idt_regrain=uint8(IR_idt_regrain)+background;
% 
% %         % show results
% %         figure, subplot(1,3,1),imshow(final_IR_mkl), title('MKL');
% %         subplot(1,3,2),imshow(final_IR_idt), title('IDT');
% %         subplot(1,3,3),imshow(final_IR_idt_regrain), title('IDT and Regrain');
% %         
%         % save image
%         filepath=pwd;
%         cd(sprintf('E:\\coco\\composite_images\\%s_idt\\composite',dataType));
%         %imwrite(final_IR_mkl,sprintf('%s_mkl_%s_%g_%g.jpg',dataType,cat.name,imgId1,imgId2)); 
%         imwrite(final_IR_idt_regrain,sprintf('%s_%g_idt_%g.jpg',dataType,imgId1,imgId2)); 
%         cd(filepath);    
%% cumulative histogram matching 
% 
%         new_im1 = perform_cumulative_histogram_mapping(I1, I2, bm1>0, bm2>0);
%         
% %         % show images
% %         figure, subplot(1,3,1), imshow(I1), title('target image');
% %         subplot(1,3,2), imshow(I2), title('reference image');
% %         subplot(1,3,3), imshow(new_im1), title('converted target image');
%         
%         % save image
%         filepath=pwd;
%         cd(sprintf('E:\\coco\\composite_images\\%s_hgm\\composite',dataType));
%         imwrite(new_im1,sprintf('%s_%g_hgm_%g.jpg',dataType,imgId1,imgId2)); 
%         cd(filepath);
        end
        
    end
end
disp('done');
