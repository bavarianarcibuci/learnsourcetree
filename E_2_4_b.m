clc
clear all

image = double( imread( 'data/images/lena_small.tif' ) );
image_YCbCr = ictRGB2YCbCr( image );
[ height width dimension ] = size( image_YCbCr );


for i = 1 : height-1
    for j = 1 : width-1
        prediction( i+1, j+1, 1 ) = 7/8 * ( image_YCbCr( i+1, j, 1 ) ) -1/2 * ( image_YCbCr( i, j, 1 ) )+ 5/8 * ( image_YCbCr( i, j+1, 1 ) );
        error( i+1, j+1, 1 ) = image_YCbCr( i+1, j+1, 1 ) - prediction( i+1, j+1, 1 );
        
        prediction( i+1, j+1, 2 ) = 3/8 * ( image_YCbCr( i+1, j, 2 ) ) - 1/4 * ( image_YCbCr( i, j, 2 ) ) + 7/8 * ( image_YCbCr( i, j+1, 2 ) );
        error( i+1, j+1, 2 ) = image_YCbCr( i+1, j+1, 2 ) - prediction( i+1, j+1, 2 );
    
        prediction( i+1, j+1, 3 ) = 3/8 * ( image_YCbCr(i+1, j, 3 ) ) - 1/4 * ( image_YCbCr( i, j, 3 ) ) + 7/8 * ( image_YCbCr( i, j+1, 3 ) );
        error( i+1, j+1, 3 ) = image_YCbCr( i+1, j+1, 3 ) - prediction( i+1, j+1, 3 );
    end
end
pmf = hist( error( : ), -383:383 ); % max error = 255*(7/8 + 5/8)-0
pmf = pmf / sum( pmf ) + eps;
entropy = - sum( pmf( : ) .* log2( pmf( : ) ) ) 
 
