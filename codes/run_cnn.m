function [ dehaze ] = run_cnn( im )
%RUN_CNN Summary of this function goes here
%   Detailed explanation goes here

r0 = 50;
% eps = 10^-3; 
eps = 10^-1; 
gray_I = rgb2gray(im);

load dehaze
haze=im-0.5;

%% Feature Extraction F1
f1=convolution(haze, weights_conv1, biases_conv1);
figure;
imshow((f1(:,:,1)))
figure;
imshow((f1(:,:,2)))
figure;
imshow((f1(:,:,end)))
title('F1')
axis off
F1=[];
f1temp=reshape(f1,size(f1,1)*size(f1,2),size(f1,3));
for step=1:4
    maxtemp=max(f1temp(:,(step*4-3):step*4),[],2);
    F1=[F1,maxtemp]; %#ok<AGROW>
end
F1=reshape(F1,size(f1,1),size(f1,2),size(F1,2));

%% Multi-scale Mapping F2
F2=zeros(size(F1,1),size(F1,2),48);
F2(:,:,1:16)=convolution(F1, weights_conv3x3, biases_conv3x3);
F2(:,:,17:32)=convolution(F1, weights_conv5x5, biases_conv5x5);
F2(:,:,33:48)=convolution(F1, weights_conv7x7, biases_conv7x7);
figure;
imshow((F2(:,:,end)))
title('F2')
%% Local Extremum F3
F3=convMax(single(F2), 3);
figure;
imshow((F3(:,:,end)))
title('F3')
figure;
imagesc(((F3(:,:,end))))
axis off
%% Non-linear Regression F4
F4=min(max(convolution(F3, weights_ip, biases_ip),0),1);
figure;
imshow((F4(:,:,1)))
title('F4')
figure;
imshow((F4(:,:,end)))
title('F4')
%% Atmospheric light
sortdata = sort(F4(:), 'ascend');
idx = round(0.01 * length(sortdata));
val = sortdata(idx); 
id_set = find(F4 <= val);
BrightPxls = gray_I(id_set);
iBright = BrightPxls >= max(BrightPxls);
id = id_set(iBright);
Itemp=reshape(im,size(im,1)*size(im,2),size(im,3));
A = mean(Itemp(id, :),1);
A=reshape(A,1,1,3);
F4 = guidedfilter(gray_I, F4, r0, eps);
figure;
imagesc(((F4)))
axis off
J=bsxfun(@minus,im,A);
J=bsxfun(@rdivide,J,F4);
J=bsxfun(@plus,J,A);
dehaze=J;
end

