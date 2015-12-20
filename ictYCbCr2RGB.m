function [image_RGB] =ictYCbCr2RGB(image_YCbCr)

Y = image_YCbCr( :, :, 1 );
Cb = image_YCbCr( :, :, 2 );
Cr = image_YCbCr( :, :, 3 );

R = Y + 1.402 * Cr;
G = Y - 0.344 * Cb - 0.714 * Cr;
B = Y + 1.772 * Cb;

image_RGB( :, :, 1 ) = R;
image_RGB( :, :, 2 ) = G;
image_RGB( :, :, 3 ) = B;

end