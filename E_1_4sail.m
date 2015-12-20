clc
clear

image = double( imread( 'data/images/sail.tif' ) );

[ height, width, dimension ] = size( image );


for i = 1 : 3
    image_wrf( :, :, i ) = padarray( image( :, :, i ), [ 4, 4 ], 'symmetric', 'both');
    image_rf( :, :, i ) = resample( resample( image_wrf( :, :, i ), 1, 2, 3 )',1, 2, 3)';
    image_cbf( :, :, i ) = image_rf( 3 : 258, 3 : 386, i );
    image_wrb( :, :, i ) = padarray( image_cbf( :, :, i ), [ 4, 4 ], 'symmetric', 'both');
    image_rb( :, :, i ) = resample( resample( image_wrb( :, :, i ), 2, 1, 3 )', 2, 1, 3 )';
    image_cbb( :, :, i ) = image_rb( 9 : 520, 9 : 776, i );
end


subplot( 2, 4, 1 )
imshow( image / 256 );
title( 'original image' );

subplot( 2, 4, 2 )
imshow( image_wrf / 256 );
title( 'wrap around forward' );

subplot( 2, 4, 3 )
imshow( image_rf / 256 );
title('resample forward');

subplot( 2, 4, 4 )
imshow( image_cbf / 256 );
title( 'crop back forward' );

subplot( 2, 4, 5 )
imshow( image_wrb / 256 );
title( 'wrap around back' );

subplot( 2, 4, 6 )
imshow( image_rb / 256 );
title( 'resample back' );

subplot( 2, 4, 7 )
imshow( image_cbb / 256 );
title( 'reconstructed image' );



MSE = calcMSE( image, image_cbb, dimension, height, width );
PSNR = calcPSNR( MSE );
fprintf( 'PSNR is %f \n' , PSNR )


