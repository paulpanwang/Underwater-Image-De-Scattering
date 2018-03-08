%第一题：hpfilter.m
%本程序实现的是IHPF、BHPF、EHPF的传递函数
%@author：吴腾飞
function[H,D] = hpfilter(type,M,N,D0,nn)
%计算频域矩阵
U = 0 : (M - 1);%设置U的范围
V = 0 : (N - 1);%设置V的范围
%计算矩阵使用的索引值
idx = find(U > M/2);
U(idx) = U(idx) - M;
idy = find(V > N/2);
V(idy) = V(idy) - N;
[V,U] = meshgrid(V,U);%计算点阵矩阵
D = sqrt(U.^2 + V.^2);%计算频域点D(u,v)到原点的距离D
%滤波器的传递函数
switch type
    case 'ideal' %IHPF传递函数
        H = double(D>D0);
    case 'btw' %BHPF传递函数
        if nargin ==4
            nn =1;
        end
        H = 1./(1+(sqrt(2)-1)*(D0./D).^nn);
    case 'expotential' %EHPF传递函数
        H = exp(log(1/sqrt(2))*(D0./D).^nn);
    otherwise
        error('unkown filter type')
end
