clc
clear all

image = double( imread( 'data/images/lena.tif' ) );
[ height width dimension ] = size( image );

for k = 1 : dimension
    for j = 1 : height
        for i = 1 : width - 1
            error ( j, i, k ) = image( j, i+1, k ) - image( j, i, k );
        end
    end
end

pmf = hist( error( : ), -255 : 255 );
pmf = pmf / sum( pmf ) + eps;
entropy = -sum( pmf( : ) .* log2( pmf( : ) ) )