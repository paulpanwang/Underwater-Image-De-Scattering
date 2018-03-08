function f = MyHistogramEqulization(img)  
[nHeight, nWidth, nDim] = size(img);  
if nDim == 3  
    img = rgb2gray(img);  
end  
height = size(img, 1);  
width = size(img, 2);  
% 图像中所有的像素的个数  
numPixel = height * width;  
% 各个灰度出现的频数  
frequency = zeros(256, 1);  
% 各个灰度出现的概率  
probability = zeros(256, 1);  
% 统计各个灰度的频数，计算各个灰度的概率  
for i = 1:height  
    for j = 1:width  
        value = img(i,j);  
        frequency(value + 1) = frequency(value + 1) + 1;  
        probability(value + 1) = frequency(value + 1) / numPixel;  
    end  
end  
% 各个灰度的累积分布  
fPixel = zeros(256, 1);  
% 各个灰度的累积分布概率  
pPixel = zeros(256, 1);  
% 重新定义的灰度值  
imgNew = zeros(256, 1);  
% 累积和变量  
sum = 0;  
for i = 1:size(probability)  
    sum = sum + frequency(i);  
    fPixel(i) = sum;  
    pPixel(i) = fPixel(i) / numPixel;  
    % 计算映射的灰度值  
    imgNew(i) = round(pPixel(i) * 255);  
end  
% 生成新的图像数组。 uint8 是指生成 8 位图像数组，节约存储空间。  
f = uint8(zeros(height, width));  
for i = 1:height  
    for j = 1:width  
        f(i, j) = imgNew(img(i, j) + 1);  
    end  
end  