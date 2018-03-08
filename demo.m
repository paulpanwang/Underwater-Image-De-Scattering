clc;
clear;
addpath('codes\')
input = imread('Images\2.jpg'); 
output = underwater(input);
underwaterimage2(input);
figure,imshow(input), title('original image');
figure,imshow(output),title('enhanced image');