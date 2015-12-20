clc
clear all

image_lena = double( imread( 'data/images/lena.tif' ) );
image_sail = double( imread( 'data/images/sail.tif' ) );
image_smandril = double( imread( 'data/images/smandril.tif' ) );

image = [ image_lena, image_sail, image_smandril ];
histogram = hist( image( : ), 0 : 255 );
pmf = histogram / sum( histogram ) + eps;


pmf_lena = stats_marg( image_lena );
entropy_lena = -sum( pmf_lena .* log2( pmf ) );

pmf_sail = stats_marg( image_sail );
entropy_sail = -sum( pmf_sail .* log2( pmf ) );

pmf_smandril = stats_marg( image_smandril );
entropy_smandril = -sum( pmf_smandril .* log2( pmf ) );

fprintf('"lena.tif: "%f\n\n"sail.tif: "%f\n\n"smandril.tif: "%f', entropy_lena, entropy_sail, entropy_smandril );

