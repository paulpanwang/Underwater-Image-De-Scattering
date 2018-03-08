function dark_channel = get_dark_channel(image, win_size)

[m, n, ~] = size(image);

pad_size = floor(win_size/2);

padded_image = padarray(image, [pad_size pad_size], Inf);

dark_channel = zeros(m, n); 

for j = 1 : m
    for i = 1 : n
        patch = padded_image(j : j + (win_size-1), i : i + (win_size-1), :);
%       针对水下图像的修改取 G和  B 
        %       dark_channel(j,i) = min(patch(:)); 
         patch(:,:,1)=[];                   %s删除红色通道
%         patch(:,:,1)=255-patch(:,:,1);     %把红色通道的互补
        dark_channel(j,i) = min(patch(:));
     end
end

end