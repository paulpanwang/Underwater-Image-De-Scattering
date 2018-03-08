%简单地说:
%A为给定图像，归一化到[0,1]的矩阵
%W为双边滤波器（核）的边长/2
%定义域方差σd记为SIGMA(1),值域方差σr记为SIGMA(2)
function B = bilateral_filter(A,w,sigma)
%确认输入图像存在并且有效.
if ~exist('A','var') || isempty(A)%检测A图像是否存在
   error('Input image A is undefined or invalid.');
end
if ~isfloat(A) || ~sum([1,3] == size(A,3))
%       min(A(:)) < 0 || max(A(:)) > 1
   error(['Input image A must be a double precision ',...
          'matrix of size NxMx1 or NxMx3 on the closed ',...
          'interval [0,1].']);      
end

% 验证双边滤波器窗尺寸.
if ~exist('w','var') || isempty(w) || ...
      numel(w) ~= 1 || w < 1
   w = 3;
end
w = ceil(w);

% 验证双边滤波器标准偏差.
if ~exist('sigma','var') || isempty(sigma) || ...
      numel(sigma) ~= 2 || sigma(1) <= 0 || sigma(2) <= 0
   sigma = [3 0.1];
end

% 应用灰度或彩色双边滤波.
if size(A,3) == 1
    B = bfltGray(A,w,sigma(1),sigma(2));
else
    B = bfltColor(A,w,sigma(1),sigma(2));
    % 滤波图像转换回sRGB色彩空间。
    if exist('applycform','file')
        B = applycform(B,makecform('lab2srgb'));
    else
        B = colorspace('RGB<-Lab',B);
    end
end

end




