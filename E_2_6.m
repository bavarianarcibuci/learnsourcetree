clc
clear all

image = double( imread( 'data/images/lena.tif' ) );
image_YCbCr = ictRGB2YCbCr( image );
[ height_original width_original dimension_original ]=size( image );



%subsample the image
for i = 2 : 3
    image_YCbCr_downsample( :, :, i )= resample( resample( image_YCbCr( :, :, i ), 1, 2, 3 )', 1, 2, 3 )';     %downsample
end



%calculate the PMF of sampled image
[ height_downsample width_downsample dimension_downsample ]=size( image_YCbCr_downsample );

for i = 1 : height_original-1
    for j = 1 : width_original-1
        prediction_luminance( i+1, j+1 ) = 7/8 * ( image_YCbCr( i+1, j, 1 ) ) - 1/2 * ( image_YCbCr( i, j, 1 ) ) + 5/8 * ( image_YCbCr( i, j+1, 1 ) );
        error_luminance( i, j ) = image_YCbCr( i+1, j+1, 1 ) - prediction_luminance( i+1, j+1 );
    end
end

for i = 1 : height_downsample-1
    for j = 1 : width_downsample-1
        prediction_Cb( i+1, j+1 ) = 3/8 * ( image_YCbCr_downsample( i+1, j, 2 ) ) - 1/4 * ( image_YCbCr_downsample( i, j, 2 ) ) + 7/8 * ( image_YCbCr_downsample( i, j+1, 2 ) );
        error_Cb( i, j ) = image_YCbCr_downsample( i+1, j+1, 2 ) - prediction_Cb( i+1, j+1 );
    
        prediction_Cr( i+1, j+1 ) = 3/8 * ( image_YCbCr_downsample(i+1, j, 3 ) ) - 1/4 * ( image_YCbCr_downsample( i, j, 3 ) ) + 7/8 * ( image_YCbCr_downsample( i, j+1, 3 ) );
        error_Cr( i, j ) = image_YCbCr_downsample( i+1, j+1, 3 ) - prediction_Cr( i+1, j+1 );
    end
end

error = [ error_luminance(:); error_Cb(:); error_Cr(:) ];
error = round( error );
pmf = hist( error, min(error) : max(error) );
pmf = pmf / sum( pmf ) + eps;
entropy = - sum( pmf( : ) .* log2( pmf( : ) ) );



%build huffman code
[BinaryTree, HuffCode, BinCode, Codelengths] = buildHuffman( pmf );



%encode
bytestream = enc_huffman_new( error - min(error) + 1, BinCode, Codelengths);



%decode
de_error = dec_huffman_new ( bytestream, BinaryTree, length( error ) ) + min(error) - 1;

bit_rate = length( bytestream ) *8 / ( height_original * width_original )
compression_ratio = 24 / bit_rate




%reshape
error_reconstructed_luminance = reshape( de_error( 1 : ( height_original - 1 ) * ( width_original - 1 ) ), ( height_original - 1 ), ( width_original - 1 ) );
error_reconstructed_Cb = reshape( de_error( ( height_original - 1 ) * ( width_original - 1 ) + 1 : ( height_original - 1 ) * ( width_original - 1 ) + ( height_downsample - 1 ) * ( width_downsample - 1 ) ), ( height_downsample - 1 ), ( width_downsample - 1 ) );
error_reconstructed_Cr = reshape( de_error( end - ( height_downsample - 1 ) * ( width_downsample - 1 ) + 1 : end ), ( height_downsample - 1 ), ( width_downsample - 1 ) );

image_reconstructed_luminance = zeros( size( image_YCbCr( :, :, 1 ) ) );
image_reconstructed_luminance( 1, : ) = image_YCbCr( 1, :, 1 );
image_reconstructed_luminance( :, 1 ) = image_YCbCr( :, 1, 1 );

image_reconstructed_chrominance = zeros( size( image_YCbCr_downsample ) );
image_reconstructed_chrominance( 1, :, 2 ) = image_YCbCr_downsample( 1, :, 2 );
image_reconstructed_chrominance( :, 1, 2 ) = image_YCbCr_downsample( :, 1, 2 );
image_reconstructed_chrominance( 1, :, 3 ) = image_YCbCr_downsample( 1, :, 3 );
image_reconstructed_chrominance( :, 1, 3 ) = image_YCbCr_downsample( :, 1, 3 );



%prediction
for i = 1 : height_original-1
    for j = 1 : width_original-1
        prediction__reconstructed_luminance( i+1, j+1 ) = 7/8 * ( image_YCbCr( i+1, j, 1 ) ) -1/2 * ( image_YCbCr( i, j, 1 ) )+ 5/8 * ( image_YCbCr( i, j+1, 1 ) );
        image_reconstructed_luminance( i+1, j+1 ) = prediction__reconstructed_luminance( i+1, j+1 ) + error_reconstructed_luminance( i, j );
    end
end

for i = 1 : height_downsample-1
    for j = 1 : width_downsample-1
        prediction__reconstructed_Cb( i+1, j+1 ) = 3/8 * ( image_YCbCr_downsample( i+1, j, 2 ) ) - 1/4 * ( image_YCbCr_downsample( i, j, 2 ) ) + 7/8 * ( image_YCbCr_downsample( i, j+1, 2 ) );
        image_reconstructed_chrominance( i+1, j+1, 2 ) = prediction__reconstructed_Cb( i+1, j+1 ) + error_reconstructed_Cb( i, j );
    
        prediction__reconstructed_Cr( i+1, j+1 ) = 3/8 * ( image_YCbCr_downsample( i+1, j, 3 ) ) - 1/4 * ( image_YCbCr_downsample( i, j, 3 ) ) + 7/8 * ( image_YCbCr_downsample( i, j+1, 3 ) );
        image_reconstructed_chrominance( i+1, j+1, 3 ) = prediction__reconstructed_Cr( i+1, j+1 ) + error_reconstructed_Cr( i, j );
    end
end



%reconstruction
image_reconstructed_YCbCr( :, :, 1 ) = image_reconstructed_luminance( :, :, 1 );
image_reconstructed_YCbCr( :, :, 2 ) = resample( resample( image_reconstructed_chrominance( :, :, 2 ), 2, 1, 3 )', 2, 1, 3 )';
image_reconstructed_YCbCr( :, :, 3 ) = resample( resample( image_reconstructed_chrominance( :, :, 3 ), 2, 1, 3 )', 2, 1, 3 )';
image_reconstructed_RGB = round( ictYCbCr2RGB( image_reconstructed_YCbCr ) );



%calculate PSNR
MSE = calcMSE( image, image_reconstructed_RGB, height_original, width_original, dimension_original );
PSNR = calcPSNR( MSE )



