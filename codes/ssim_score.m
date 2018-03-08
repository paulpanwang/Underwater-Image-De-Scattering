I1 = imread('16.jpg');
I1 = imresize(I1,0.1);
I2 = imread('img1.jpg');
out_ssim = ssim(I1,I2)