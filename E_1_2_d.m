image = double( imread( 'data/images/satpic1.bmp' ) );

w1 = [ 1, 2, 1; 2, 4, 2; 1, 2, 1 ]/16;
image_prefiltered = prefilterlowpass2d(image, w1);

image_downsample( :, :, 1 ) = downsample( downsample( image_prefiltered( :, :, 1 ), 2 )', 2 )';
image_downsample( :, :, 2 ) = downsample( downsample( image_prefiltered( :, :, 2 ), 2 )', 2 )';
image_downsample( :, :, 3 ) = downsample( downsample( image_prefiltered( :, :, 3 ), 2 )', 2 )';

image_upsample( :, :, 1 ) = upsample( upsample( image_downsample( :, :, 1 ), 2 )', 2 )';
image_upsample( :, :, 2 ) = upsample( upsample( image_downsample( :, :, 2 ), 2 )', 2 )';
image_upsample( :, :, 3 ) = upsample( upsample( image_downsample( :, :, 3 ), 2 )', 2 )';
 

subplot( 2, 2, 1 );
imshow( image / 256 );
title( 'unfiltered image' );

subplot( 2, 2, 2 );
imshow( image_prefiltered / 256 );
title( 'filtered image' );

subplot( 2, 2, 3 );
imshow( image_downsample / 256 );
title( 'downsampled image' );

subplot( 2, 2, 4 );
imshow( image_upsample / 256 );
title( 'upsampled image' );