clc;
clear;

image = double( imread( 'data/images/satpic1.bmp' ) );

[ height, width, dimension ] = size( image );

w1=[ 1, 2, 1; 2, 4, 2; 1, 2, 1 ] / 16;

image_prefiltered = prefilterlowpass2d( image, w1 );     %prefiltered image

image_downsample( :, :, 1 )= downsample( downsample( image_prefiltered( :, :, 1 ), 2 )', 2 )';     %downsampled image
image_downsample( :, :, 2 )= downsample( downsample( image_prefiltered( :, :, 2 ), 2 )', 2 )';
image_downsample( :, :, 3 )= downsample( downsample( image_prefiltered( :, :, 3 ), 2 )', 2 )';  

image_upsample( :, :, 1 )= upsample( upsample( image_downsample( :, :, 1 ), 2 )', 2 )';     %upsampled image
image_upsample( :, :, 2 )= upsample( upsample( image_downsample( :, :, 2 ), 2 )', 2 )';
image_upsample( :, :, 3 )= upsample( upsample( image_downsample( :, :, 3 ), 2 )', 2 )';

image_postfiltered = prefilterlowpass2d( image_upsample * 4, w1 );     %post filtered image

MSE_wpf = calcMSE( image, image_postfiltered, dimension, height, width );
PSNR_wpf = calcPSNR( MSE_wpf );
fprintf( 'PSNR(prefiltered) is %f \n', PSNR_wpf );



image_downsample_wopf( :, :, 1 )= downsample( downsample( image( :, :, 1 ), 2 )', 2 )';     %subsample image without prefiltered
image_downsample_wopf( :, :, 2 )= downsample( downsample( image( :, :, 2 ), 2 )', 2 )';
image_downsample_wopf( :, :, 3 )= downsample( downsample( image( :, :, 3 ), 2 )', 2 )';

image_upsample_wopf( :, :, 1 )= upsample( upsample( image_downsample_wopf( :, :, 1 ), 2 )', 2 )';     %upsample image without prefiltered
image_upsample_wopf( :, :, 2 )= upsample( upsample( image_downsample_wopf( :, :, 2 ), 2 )', 2 )';
image_upsample_wopf( :, :, 3 )= upsample( upsample( image_downsample_wopf( :, :, 3 ), 2 )', 2 )';

image_postfiltered_wopf = prefilterlowpass2d( image_upsample_wopf * 4, w1 );   %post filtered image

MSE_wopf = calcMSE( image, image_postfiltered_wopf, dimension, height, width );
PSNR_wopf = calcPSNR( MSE_wopf );
fprintf( 'PSNR(not prefiltered) is %f \n', PSNR_wopf )

subplot( 1, 3, 1 )
imshow( image / 256 );
title( 'original image' );

subplot( 1, 3, 2 )
imshow( image_postfiltered / 256 );
title( 'prefiltered-reconstructed image' );

subplot( 1, 3, 3 )
imshow( image_postfiltered_wopf / 256 );
title( 'unprefiltered-reconstructed image' );