clear all; close all; clc;
img=double(imread('Images\4.jpg'));
[m n]=size(img);

w=1/256*[  4  6  4 1;      %拉普拉斯滤波器
16 24 16 4;
24 36 24 6;
16 24 16 4;
 4  6  4 1];

imgn{1}=img;
for i=2:5                   %滤波，下采样
   imgn{i}=imfilter(imgn{i-1},w,'replicate');
   imgn{i}=imgn{i}(1:2:size(imgn{i},1)-1,1:2:size(imgn{i},2)-1); %i-1级近似
end
       
for i=5:-1:2        %调整图像大小
   imgn{i-1}=imgn{i-1}(1:2*size(imgn{i},1),1:2*size(imgn{i},2)); 
end

 for i=1:4          %获得残差图像，i级预测残差
    imgn{i}=imgn{i}-expand(imgn{i+1},w);    
    imwrite((uint8(imgn{i})),['result\La2_',num2str(i),'.jpg']);
 end
 
for i=4:-1:1        %残差图像重构原图像
    imgn{i}=imgn{i}+expand(imgn{i+1},w);
end

imshow(uint8(imgn{1}));