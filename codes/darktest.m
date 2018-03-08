function [J]=darktest(I)
w0=0.95;   % 乘积因子   
t0=0.1;
% figure;
% set(gcf,'outerposition',get(0,'screensize'));
% subplot(121)
% imshow(I);
% title('原始图像');

[h,w,s]=size(I);
min_I=ones(h,w);           
%暗通道估计传输图
%下面取得暗影通道图像
for i=1:h                 
    for j=1:w
        dark_I(i,j)=(min(I(i,j,:)));
    end
end
% win_size = 7;
% img_size=w*h;
% figure, imshow(I);
% dark_I=ones(h,w);
% %计算分块darkchannel
%  for j=1+win_size:w-win_size
%     for i=win_size+1:h-win_size
%         m_pos_min = min(I(i,j,:));
%         for n=j-win_size:j+win_size
%             for m=i-win_size:i+win_size
%                 if(dark_I(m,n)>m_pos_min)
%                     dark_I(m,n)=m_pos_min;
%                 end
%             end
%         end
%     end
%  end

Max_dark_channel=double(max(max(dark_I))) ; %获取亮度
dark_channel=double(dark_I);
t=1-w0*(dark_channel/Max_dark_channel);   %取得透谢分布率图

t=max(t,t0);
figure(1)
imshow(dark_channel);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I1=double(I);
J(:,:,1) = uint8((I1(:,:,1) - (1-t)*Max_dark_channel)./t);

J(:,:,2) = uint8((I1(:,:,2) - (1-t)*Max_dark_channel)./t);

J(:,:,3) =uint8((I1(:,:,3) - (1-t)*Max_dark_channel)./t);
% subplot(122)
imshow(J);
title('处理后的图像');

end

