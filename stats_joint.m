function [ pmf ] = stats_joint( image )

image = double( imread( 'data/images/lena.tif' ) );
[ height width dimension ] = size( image );
 
counter = zeros( 256 );

for k = 1 : dimension
    for j = 1 : height
        for i = 1 : 2: width - 1
            counter ( image( j, i, k ), image( j, i+1, k ) ) = counter ( image( j, i, k ), image( j, i+1, k ) ) + 1;
        end
    end
end

pmf = counter / sum( counter( : ) ) + eps;
mesh( pmf )

end