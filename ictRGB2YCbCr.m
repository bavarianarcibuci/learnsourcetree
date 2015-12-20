function [image_YCbCr] =ictRGB2YCbCr(image_RGB)

R = image_RGB( :, :, 1 );
G = image_RGB( :, :, 2 );
B = image_RGB( :, :, 3 );

Y = 0.299 * R + 0.587 * G + 0.114 * B;
Cb = -0.169 * R - 0.331 * G + 0.5 * B;
Cr = 0.5 * R - 0.419 * G - 0.081 * B;

image_YCbCr( :, :, 1 ) = Y;
image_YCbCr( :, :, 2 ) = Cb;
image_YCbCr( :, :, 3 ) = Cr;

end