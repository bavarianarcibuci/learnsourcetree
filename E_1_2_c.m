image = double( imread( 'data/images/satpic1.bmp' ) );

w1 = [ 1, 2, 1; 2, 4, 2; 1, 2, 1 ]/16;
image_prefiltered = prefilterlowpass2d(image, w1);

subplot( 1, 2, 1 );
imshow( image / 256 );
title( 'unfiltered image' );

subplot( 1, 2, 2 );
imshow( image_prefiltered / 256 );
title( 'filtered image' );