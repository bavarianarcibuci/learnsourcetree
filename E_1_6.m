clc
clear

image_RGB = double( imread( 'data/images/sail.tif' ) );

[ height, width, dimension ]=size( image_RGB );


image_YCbCr = ictRGB2YCbCr( image_RGB );  % RGB to YCbCr

for i = 2 : 3
    image_YCbCr_downsample( :, :, i )= resample( resample( image_YCbCr( :, :, i ), 1, 2, 3 )', 1, 2, 3 )';     %downsample
end

for i = 2 : 3
    image_YCbCr_upsample( :, :, i )= resample( resample( image_YCbCr_downsample( :, :, i ), 2, 1, 3 )', 2, 1, 3 )';     %upsample
end

image_YCbCr_upsample (:, :, 1 ) = image_YCbCr( :, :, 1 );

image_reconstructed = round( ictYCbCr2RGB( image_YCbCr_upsample ) );  %YCbCr to RGB


subplot( 1, 2, 1 )
imshow( image_RGB / 256 );
title( 'original image' );

subplot( 1, 2, 2 )
imshow( image_reconstructed / 256 );
title( 'reconstructed image' );

MSE = calcMSE( image_RGB, image_reconstructed, dimension, height, width );
PSNR = calcPSNR( MSE );
fprintf('PSNR is %f \n' , PSNR)
