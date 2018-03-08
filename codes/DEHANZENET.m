img = imread('Images\2.jpg');
de_dark=dehaze_fast(double(img));
figure, imshow([img, de_dark])
title('LEFT: Input image,   RIGHT: Final result');