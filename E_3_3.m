clc
clear all

image = double( imread( 'data/images/lena.tif' ) );
[ height width dimension ] = size( image );



representatives = LloydMax3( image, 0.001) ;

for i = 1:height
    for j = 1:width
        for k = 1:dimension
            [ error(i,j,k), index(i,j,k) ] = min( abs( image(i,j,k) - representatives ) );
            image_reconstructed_LM(i,j,k) = round( representatives( index(i,j,k) ) );
        end
    end
end

MSE_LM = calcMSE( image, image_reconstructed_LM, dimension, height, width );
PSNR_LM = calcPSNR( MSE_LM );
subplot(1,2,1);
imshow( image_reconstructed_LM / 256 );

image_quantized_U = UniQuant( image, 3 );
image_reconstructed_U = InvUniQuant( image_quantized_U, 3 );
MSE_U = calcMSE( image, image_reconstructed_U, dimension, height, width );
PSNR_U = calcPSNR( MSE_U );
subplot(1,2,2);
imshow( image_reconstructed_U / 256 );