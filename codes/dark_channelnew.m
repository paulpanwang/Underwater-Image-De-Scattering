clc;
clear all;close all;
img_name='11w=-3Xt=1e-07.jpg';
% 原始图像
I=double(imread(img_name))/255;
%   I = imresize(I,0.5);
% 获取图像大小
[h,w,c]=size(I);
win_size = 3;
img_size=w*h;
figure, imshow(I);
win_dark=ones(h,w);
%计算分块darkchannel
 for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        m_pos_min = min(I(i,j,:));
        for n=j-win_size:j+win_size
            for m=i-win_size:i+win_size
                if(win_dark(m,n)>m_pos_min)
                    win_dark(m,n)=m_pos_min;
                end
            end
        end
    end
 end
 %选定精确dark value坐标
% win_b = zeros(img_size,1);
 figure, imshow(win_dark);
 win_t=1-0.95*win_dark;
 win_b=zeros(img_size,1);
for ci=1:h
    for cj=1:w
        if(rem(ci-8,15)<1)
            if(rem(cj-8,15)<1)
                win_b(ci*w+cj)=win_t(ci*w+cj);
            end
        end
    end
end
 
%显示分块darkchannel
%figure, imshow(win_dark);
neb_size = 9;
win_size = 1;
epsilon = 0.000001;
%指定矩阵形状
indsM=reshape(1:img_size,h,w);
%计算矩阵L
tlen = img_size*neb_size^2;
row_inds=zeros(tlen ,1);
col_inds=zeros(tlen,1);
vals=zeros(tlen,1);
len=0;
for j=1+win_size:w-win_size
    for i=win_size+1:h-win_size
        if(rem(h-8,15)<1)
            if(rem(w-8,15)<1)
                continue;
            end
        end
      win_inds=indsM(i-win_size:i+win_size,j-win_size:j+win_size);
      win_inds=win_inds(:);%列显示
      winI=I(i-win_size:i+win_size,j-win_size:j+win_size,:);
      winI=reshape(winI,neb_size,c); %三个通道被拉平成为一个二维矩阵 9*3
      win_mu=mean(winI,1)';  %求每一列的均值 如果第二个参数为2 则为求每一行的均值  //矩阵变向量
      win_var=winI'*winI/neb_size-win_mu*win_mu'+epsilon/neb_size*eye(c); %求方差
      winI=winI-repmat(win_mu',neb_size,1);%求离差
      tvals=(1+winI/win_var*winI')/neb_size;% 求论文所指的矩阵L
      row_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds,1,neb_size),...
                                             neb_size^2,1);
      col_inds(1+len:neb_size^2+len)=reshape(repmat(win_inds',neb_size,1),...
                                             neb_size^2,1);
      vals(1+len:neb_size^2+len)=tvals(:);
      len=len+neb_size^2;
    end
end 
 
 
vals=vals(1:len);
row_inds=row_inds(1:len);
col_inds=col_inds(1:len);
%创建稀疏矩阵
A=sparse(row_inds,col_inds,vals,img_size,img_size);
%求行的总和 
sumA=sum(A,2);
%spdiags(sumA(:),0,img_size,img_size) 创建img_size大小的稀疏矩阵其元素是sumA中的列元素放在由0指定的对角线位置上。
A=spdiags(sumA(:),0,img_size,img_size)-A;


  %创建稀疏矩阵
  D=spdiags(win_b(:),0,img_size,img_size);
  lambda=1;
  x=(A+lambda*D)\(lambda*(win_b(:).*win_b(:)));
   %去掉0-1范围以外的数
  alpha=max(min(reshape(x,h,w),1),0);
 
figure, imshow(alpha);
% **************************************************
%     自动获取大气光步骤，A为最终大气光的值
% **************************************************
range=ceil(img_size*0.1);%取暗原色中最亮的%1的点数
radi_pro=zeros(range,1); %用于记录最亮点内对应图片点象素的三个通道的颜色强度
      for s=1:range
          [a,b]=max(win_dark);  
          [c,d]=max(a);
          b=b(d);
          m=sparse(b,d,1,h,w);        %b,d为最亮值的坐标
          win_dark=win_dark-c.*m;     %消去选出的最大值
          radi_pro(s)=sum(I(b,d,:));  %最大值对应象素三通道求和
      end
A=max(radi_pro)/3;%大气光的值
% **************************************************
%  算法改进步骤，可修正天空透射率以减小明亮部分的失真率
% **************************************************
inten=zeros(h,w);
    for m=1:h
        for n=1:w
            inten(m,n)=mean(I(m,n,:));
        end
    end
k=70;    
k=zeros(h,w)+k/255; %容差
% A=220/255;
cha=abs(inten-A);   %差限
alpha=min(max(k./cha,1).*max(alpha,0.1),1); %算法改进关键部分
figure,imshow(alpha);
% ***************************************************
alpha=repmat(alpha,[1,1,3]);   
dehaze=(I-A)./alpha+A;  
figure, imshow(dehaze);