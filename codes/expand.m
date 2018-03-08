function re=expand(img,w)

    img=double(img);
    w=w*4;
    
    [m n]=size(img);
    [M N]=size(w);
    
    %插入滤波器                                   
    w_up_left=w(1:2:M,1:2:N); 
    w_up_right=w(1:2:M,2:2:N); 
    w_down_left=w(2:2:M,1:2:N); 
    w_down_right=w(2:2:M,2:2:N); 

    img_up_left=imfilter(img,w_up_left,'replicate','same');
    img_up_right=imfilter(img,w_up_right,'replicate','same');   
    img_down_left=imfilter(img,w_down_left,'replicate','same');  
    img_down_right=imfilter(img,w_down_right,'replicate','same');  
  
    re= zeros(m*2,n*2);             %上采样
    re(1:2:m*2,1:2:n*2)=img_up_left;
    re(2:2:m*2,1:2:n*2)=img_up_right;
    re(1:2:m*2,2:2:n*2)=img_down_left;
    re(2:2:m*2,2:2:n*2)=img_down_right;

end