clc
clear all

image = double( imread( 'data/images/lena.tif' ) );
pmf = stats_joint( image );
entropy = - sum( pmf( : ) .* log2( pmf( : ) ) )