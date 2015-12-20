clear all
clc

image = double( imread( 'data/images/lena_small.tif' ) );
[ height, width, dimension ] = size( image );


M = 8;
epsilon = 0.1;
D_previous = 1;
D_next = 11;
index = zeros( size( image ) );
error = zeros( size( image ) );
%index_lena_small = zeros( length(image(:))/4, 1 );
index_lena_small = zeros( size( image ) );

for m = 1 : 2^M
    representatives(m) = ( ( m-1 ) * ( 1 / 2^M ) + 1 / 2^(M+1) ) * 256; %Representatives
end

%Quantization table initialization
%The first four columns are the representative values in 2 by 2 blocks
%The next four columns are the sum of each intesive value which are quantized
%in corresponding intervals
%The 9th column is the sum of four intesive values in one block which are
%quantized in corrsponding intervals

quan_table = zeros( length(representatives), 9 ); 
for n = 1 : 4
    quan_table( :,n ) = representatives; 
end


while abs( D_next - D_previous ) / D_next >= epsilon
    
    for i=1:2:(height-1)
        for j=1:2:(width-1)
            for k=1:dimension
                
                [ error(i,j,k), index(i,j,k) ] = min( abs( image(i,j,k) - quan_table(:,1) ) + abs( image(i+1,j,k) - quan_table(:,2) ) + abs( image(i,j+1,k) - quan_table(:,3) ) + abs( image(i+1,j+1,k) - quan_table(:,4) ) );
                
                quan_table( index(i,j,k), 5 ) = quan_table( index(i,j,k), 5) + image(i,j,k);
                quan_table( index(i,j,k), 6 ) = quan_table( index(i,j,k), 6) + image(i+1,j,k);
                quan_table( index(i,j,k), 7 ) = quan_table( index(i,j,k), 7) + image(i,j+1,k);
                quan_table( index(i,j,k), 8 ) = quan_table( index(i,j,k), 8) + image(i+1,j+1,k);
                quan_table( index(i,j,k), 9 ) = quan_table( index(i,j,k), 9 ) + 1;
            end
        end
    end
    
     for h = 1 : 2^M
        if quan_table( h, 9 ) ~= 0 %Update representative values of intervals which at least one intensity value is belongs to
            quan_table( h, 1 ) = quan_table( h, 5 ) ./ quan_table( h, 9 );
            quan_table( h, 2 ) = quan_table( h, 6 ) ./ quan_table( h, 9 );
            quan_table( h, 3 ) = quan_table( h, 7 ) ./ quan_table( h, 9 );
            quan_table( h, 4 ) = quan_table( h, 8 ) ./ quan_table( h, 9 );
        end
     end
    
    for h = 1 : 2^M
        [max_Bq, index_Bq] = max( quan_table( :, 9 ) );
        if quan_table( h, 9 ) == 0 %Cell splitting
            quan_table( h, 9 ) = floor( max_Bq/2 );
            quan_table( index_Bq, 9 ) = floor( max_Bq/2 ) + 1;
            quan_table( h, 1 ) = quan_table( index_Bq, 5 ) ./ quan_table( index_Bq, 9 );
            quan_table( h, 2 ) = quan_table( index_Bq, 6 ) ./ quan_table( index_Bq, 9 );
            quan_table( h, 3 ) = quan_table( index_Bq, 7 ) ./ quan_table( index_Bq, 9 );
            quan_table( h, 4 ) = quan_table( index_Bq, 8 ) ./ quan_table( index_Bq, 9 ) + 1;
        end
    end
               
    square_error =  error.^2;
    D_previous = D_next;
    D_next = sum( square_error(:) );
    
    for n = 5 : 9
        quan_table( :,n ) = 0; 
    end

end

%Quantize lena_small
for i=1:2:(height-1)
    for j=1:2:(width-1)
        for k=1:dimension
            [ error(i,j,k), index_lena_small(i,j,k) ] = min( abs( image(i,j,k) - quan_table(:,1) ) + abs( image(i+1,j,k) - quan_table(:,2) ) + abs( image(i,j+1,k) - quan_table(:,3) ) + abs( image(i+1,j+1,k) - quan_table(:,4) ) );
        end
    end
end
index_lena_small(find(index_lena_small==0))=[];

pmf = hist( index_lena_small, min(index_lena_small) : max(index_lena_small) );
pmf = pmf / sum( pmf );

%build huffman code from lena_small
[BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( pmf );

image_lena = double( imread( 'data/images/lena.tif' ) );
[ height_lena, width_lena, dimension_lena ] = size( image_lena );
%index_lena = zeros( length(image_lena(:)) / 4, 1 );
index_lena = zeros( size( image_lena ) );

%Quantize lena
for i=1:2:(height_lena-1)
    for j=1:2:(width_lena-1)
        for k=1:dimension_lena
            [ error(i,j,k), index_lena(i,j,k) ] = min( abs( image_lena(i,j,k) - quan_table(:,1) ) + abs( image_lena(i+1,j,k) - quan_table(:,2) ) + abs( image_lena(i,j+1,k) - quan_table(:,3) ) + abs( image_lena(i+1,j+1,k) - quan_table(:,4) ) );
        end
    end
end
index_lena(find(index_lena==0))=[];

%encode
bytestream = enc_huffman_new( index_lena, BinCode, Codelengths);
bit_rate = length( bytestream ) *8 / ( height_lena * width_lena )

%decode
index_decode = dec_huffman_new ( bytestream, BinaryTree, length( index_lena ) );

%reconstruction
for j=1:2:(width_lena-1)
    for i=1:2:(height_lena-1)
        for k=1:dimension_lena
            image_lena_reconstructed(i,j,k) = quan_table( index_decode(256^2*(k-1)+256*(j-1)/2+(i+1)/2), 1);
            image_lena_reconstructed(i+1,j,k) = quan_table( index_decode(256^2*(k-1)+256*(j-1)/2+(i+1)/2), 2);
            image_lena_reconstructed(i,j+1,k) = quan_table( index_decode(256^2*(k-1)+256*(j-1)/2+(i+1)/2), 3);
            image_lena_reconstructed(i+1,j+1,k) = quan_table( index_decode(256^2*(k-1)+256*(j-1)/2+(i+1)/2), 4);
        end
    end
end

MSE_VQ = calcMSE( image_lena, image_lena_reconstructed, dimension_lena, height_lena, width_lena );
PSNR_VQ = calcPSNR( MSE_VQ );










