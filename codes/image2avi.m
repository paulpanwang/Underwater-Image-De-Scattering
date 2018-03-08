% a=(double(2*imread('1.jpg'))+2*double(imread('2.jpg'))+double(imread('3.jpg')))/4;
% 
% a=uint8(a);
% % a=white_balance(a);
% a(:,:,2)=a(:,:,2)*1.01;
% imshow(a);
% imwrite(a,['a','.jpg']);

%将所有单帧图片转换为视频
DIR='vedio\img_';        %图片所在文件夹
file=dir(strcat(DIR,'*.png'));                %读取所有jpg文件
filenum=size(file,1);                         %图片总数

obj_gray = VideoWriter('水下图像清晰化.avi');   %所转换成的视频名称
writerFrames = filenum;                       %视频帧数

%将单张图片存在avi文件
open(obj_gray);
for k = 1: writerFrames
    if sum(k==251:300)==1
        continue;
    end
    fname = strcat(DIR, num2str(k), '.png');
    frame = imread(fname);
    frame=imresize(frame,[778,1038]);
    writeVideo(obj_gray, frame);
end
close(obj_gray);