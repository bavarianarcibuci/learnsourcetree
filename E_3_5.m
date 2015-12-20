clc
clear all

main;

figure( 'Name', 'Rate-Distortion Performance' );
title( 'Rate-Distortion Performance' );
xlabel( 'bit/pixel' );
ylabel( 'PSNR' );
axis( [0 20 10 50] );

image_RGB = double( imread( 'data/images/sail.tif' ) );
[ height width dimension ] = size( image_RGB );

image_YCbCr = ictRGB2YCbCr( image_RGB );

for i = 2 : 3
    image_YCbCr_downsample( :, :, i )= resample( resample( image_YCbCr( :, :, i ), 1, 2, 3 )', 1, 2, 3 )';     %downsample
end

for i = 2 : 3
    image_YCbCr_upsample( :, :, i )= resample( resample( image_YCbCr_downsample( :, :, i ), 2, 1, 3 )', 2, 1, 3 )';     %upsample
end

image_YCbCr_upsample (:, :, 1 ) = image_YCbCr( :, :, 1 );

image_reconstructed = round( ictYCbCr2RGB( image_YCbCr_upsample ) );  %YCbCr to RGB

MSE_chrsub = calcMSE( image_RGB, image_reconstructed, dimension, height, width );
PSNR_chrsub = calcPSNR( MSE_chrsub );




for i = 1 : 3
    image_YCbCr_downsample1( :, :, i )= resample( resample( image_YCbCr( :, :, i ), 1, 2, 3 )', 1, 2, 3 )';     %downsample
end

for i = 1 : 3
    image_YCbCr_upsample1( :, :, i )= resample( resample( image_YCbCr_downsample1( :, :, i ), 2, 1, 3 )', 2, 1, 3 )';     %upsample
end

image_reconstructed = round( ictYCbCr2RGB( image_YCbCr_upsample1 ) );  %YCbCr to RGB

MSE_RGBcif = calcMSE( image_RGB, image_reconstructed, dimension, height, width );
PSNR_RGBcif = calcPSNR( MSE_RGBcif );




for i = 1 : 3
    image_YCbCr_downsample2( :, :, i )= resample( resample( image_YCbCr( :, :, i ), 1, 4, 3 )', 1, 4, 3 )';     %downsample
end

for i = 1 : 3
    image_YCbCr_upsample2( :, :, i )= resample( resample( image_YCbCr_downsample2( :, :, i ), 4, 1, 3 )', 4, 1, 3 )';     %upsample
end

image_reconstructed = round( ictYCbCr2RGB( image_YCbCr_upsample2 ) );  %YCbCr to RGB

MSE_RGBqcif = calcMSE( image_RGB, image_reconstructed, dimension, height, width );
PSNR_RGBqcif = calcPSNR( MSE_RGBqcif );


hold on
smandril = plot( 8, PeakSNR(1), 'bs' );
lena = plot( 8, PeakSNR(2), 'gs');
sail = plot( 8, PeakSNR(4), 'rs');
chrominance_sail = plot( 12,PSNR_chrsub, 'cs');
sail_sub_cif = plot( 6,PSNR_RGBcif, 'ms' );
sail_sub_qcif = plot( 1.5,PSNR_RGBqcif, 'ys' );
lena_predictive_still = plot( 6.3986, 37.4761, 'ks');
lena_vector_quantization = plot( 5.5137, 34.0221, 'bo');
hold off

legend([smandril,lena,chrominance_sail,sail,sail_sub_cif,sail_sub_qcif, lena_predictive_still, lena_vector_quantization],'smandril-al', 'lena-al','sail-chrominance','sail-al','sail-sub-CIF','sail-sub-QCIF', 'lena-predictive-still', 'lena_vector_quantization', 'Location', 'Best' );
