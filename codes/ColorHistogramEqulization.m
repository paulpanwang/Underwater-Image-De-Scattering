function newimg = ColorHistogramEqulization(img)  
[nHeight, nWidth, nDim] = size(img);  
r = img(:, :, 1);  
g = img(:, :, 2);  
b = img(:, :, 3);  
% 调用自己写的直方图均衡化函数分别对 R G B 分量进行直方图均衡化  
R = MyHistogramEqulization(r);  
G = MyHistogramEqulization(g);  
B = MyHistogramEqulization(b);  
newimg = cat(3, R, G, B);  
imshow(newimg);  
  
figure(1);  
subplot(1, 2, 1), imshow(img);  
title('均衡化之前的图像');  
subplot(1, 2, 2), imshow(newimg);  
title('均衡化之后的图像');  
  
figure(2);  
subplot(4, 3, 1), imshow(r);  
title('R 分量');  
subplot(4, 3, 2), imshow(g);  
title('G 分量');  
subplot(4, 3, 3), imshow(b);  
title('B 分量');  
subplot(4, 3, 4), imhist(r);  
subplot(4, 3, 5), imhist(g);  
subplot(4, 3, 6), imhist(b);  
subplot(4, 3, 7), imshow(R);  
subplot(4, 3, 8), imshow(G);  
subplot(4, 3, 9), imshow(B);  
subplot(4, 3, 10), imhist(R);  
subplot(4, 3, 11), imhist(G);  
subplot(4, 3, 12), imhist(B);  