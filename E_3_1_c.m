clear all
clc

image = double( imread( 'data/images/lena_small.tif' ) );
[ height, width, dimension ]=size( image );

for M = 1: 1: 7
    image_quantized = UniQuant( image, M );
    image_reconstructed = InvUniQuant( image_quantized, M );
    mse = calcMSE( image, image_reconstructed, dimension, height, width );
    PSNR = calcPSNR( mse );
    fprintf('\nPSNR of lena_small ( m=%d ): %f\n', M, PSNR );
end


image = double( imread( 'data/images/lena.tif' ) );
[ height, width, dimension ]=size( image );

for M = 3: 1: 5
    image_quantized = UniQuant( image, M );
    image_reconstructed = InvUniQuant( image_quantized, M );
    mse = calcMSE( image, image_reconstructed, dimension, height, width );
    PSNR = calcPSNR( mse );
    fprintf('\nPSNR of lena ( m=%d ): %f\n', M, PSNR );
end
