clc
clear all

image = double( imread( 'data/images/lena.tif' ) );
cond_pmf = stats_cond( image );
joint_pmf = stats_joint( image );
entropy = - sum( joint_pmf( : ) .* log2( cond_pmf( : ) ) )
