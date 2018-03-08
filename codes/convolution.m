function [ output_data ] = convolution(input_data, weights_conv, biases_conv)
%CONVOLUTION Summary of this function goes here
%   Detailed explanation goes here
weights_conv=double(weights_conv);
biases_conv=double(biases_conv);
hei = size(input_data,1);
wid = size(input_data,2);
[conv_channels,conv_patchsize2,conv_filters] = size(weights_conv);
conv_patchsize = sqrt(conv_patchsize2);

output_data = zeros(hei, wid, conv_filters);
for i = 1 : conv_filters
    for j = 1 : conv_channels
        conv_subfilter = reshape(weights_conv(j,:,i), conv_patchsize, conv_patchsize);
        output_data(:,:,i) = output_data(:,:,i) + imfilter(input_data(:,:,j), conv_subfilter, 'same', 'symmetric');
    end
    output_data(:,:,i) = output_data(:,:,i) + biases_conv(i);
end

end

