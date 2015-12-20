clc
clear

alpha = [0.1, 0.2, 0.3, 0.5, 0.8, 1, 2, 3, 4, 5];

MSE_video = zeros( 1, 10 );
PSNR_video = zeros( 1, 10 );
bit_rate_video = zeros( 1, 10 );

MSE_still = zeros( 1, 10 );
PSNR_still = zeros( 1, 10 );
bit_rate_still = zeros( 1, 10 );

for j = 1 : 10
    
    %intra decode for the first frame
    image_fore0020 = double( imread( 'data/images/akiyo20_40_RGB/akiyo0020.bmp' ) );
    [ height, width, dimension ] = size( image_fore0020 );
    code_fore0020 = IntraEncode( image_fore0020, alpha(j) );

    pmf = hist( code_fore0020, min(code_fore0020) : max(code_fore0020) );
    pmf = pmf / sum( pmf );

    %build huffman code
    [BinaryTree, HuffCode, BinCode, Codelengths ] = buildHuffman( pmf );

    %encode
    bytestream_still = enc_huffman_new( code_fore0020 - min(code_fore0020) + 1, BinCode, Codelengths );
    bit_rate_still(j) = length( bytestream_still ) *8 / ( height * width )

    %decode
    code_fore0020_decode = dec_huffman_new ( bytestream_still, BinaryTree, length(code_fore0020) ) + min(code_fore0020) - 1;

    image_fore0020_reconstructed = IntraDecode( code_fore0020_decode, height, width, dimension, alpha(j) );

    MSE_still(j) = calcMSE( image_fore0020, image_fore0020_reconstructed, dimension, height, width );
    PSNR_still(j) = calcPSNR( MSE_still(j) );

    %matrix for recording each reconstructed image, each bitrate and each PSNR
    image_predicted = image_fore0020_reconstructed;
    image_reconstructed = zeros( height, width, dimension, 21 );
    image_reconstructed( :, :, :, 1 ) = image_fore0020_reconstructed;
    error = zeros( height, width, dimension );
    bit_rate = zeros( 1, 21 );
    bit_rate(1) = bit_rate_still(j);
    MSE = zeros( 1, 21 );
    MSE(1) = MSE_still(j);
    PSNR = zeros( 1, 21 );
    PSNR(1) = PSNR_still(j);


    for i = 1:20
        image = double(imread(strcat('data/images/akiyo20_40_RGB/akiyo00', num2str(20+i), '.bmp' )));
        [ ssd, MV, MV_index ] = InterMode( image_predicted, image );
        [ height_MV, width_MV, dimension_MV] = size ( MV );

        for x = 1 : width/8
            for y = 1 : height/8           
                image_predicted_temp( (y-1)*8+1 : (y-1)*8+8, (x-1)*8+1 : (x-1)*8+8, : ) = image_predicted( (y-1)*8+1+MV(y,x,1) : (y-1)*8+8+MV(y,x,1),  (x-1)*8+1+MV(y,x,2) : (x-1)*8+8+MV(y,x,2), : );
            end
        end  

        error_temp = image - image_predicted_temp;
        error = IntraEncode( error_temp, alpha(j) );

        MV_seq = reshape( MV, 1, [] ) ;
        error_seq = round( reshape(error, 1, []) );
        pmf_error = hist( error_seq, min(error_seq) : max(error_seq) );
        pmf_error = pmf_error / sum( pmf_error );
        pmf_MV = hist( MV_seq, min(MV_seq) : max(MV_seq) );
        pmf_MV = pmf_MV / sum( pmf_MV );

        %build huffman code
        [BinaryTree_error, HuffCode_error, BinCode_error, Codelengths_error ] = buildHuffman( pmf_error );
        [BinaryTree_MV, HuffCode_MV, BinCode_MV, Codelengths_MV ] = buildHuffman( pmf_MV );

        %encode
        bytestream_error_temp = enc_huffman_new( error_seq - min(error_seq) + 1, BinCode_error, Codelengths_error );
        bit_rate_error_temp = length( bytestream_error_temp ) *8 / ( height * width );
        bytestream_MV_temp = enc_huffman_new( MV_seq - min(MV_seq) + 1, BinCode_MV, Codelengths_MV );
        bit_rate_MV_temp = length( bytestream_MV_temp ) *8 / ( height * width );
        bit_rate(i+1) = bit_rate_error_temp + bit_rate_MV_temp;

        %decode
        error_decode_seq = dec_huffman_new ( bytestream_error_temp, BinaryTree_error, length(error_seq) ) + min(error_seq) - 1;
        MV_decode_seq = dec_huffman_new ( bytestream_MV_temp, BinaryTree_MV, length(MV_seq) ) + min(MV_seq) - 1;
        error_decode = IntraDecode( error_decode_seq, height, width, dimension, alpha(j) );
        MV_decode = reshape( MV_decode_seq, height_MV, width_MV, dimension_MV );

        for x = 1  : width/8
            for y = 1 : height/8           
                image_reconstructed_temp( (y-1)*8+1 : (y-1)*8+8, (x-1)*8+1 : (x-1)*8+8, :) = image_predicted( (y-1)*8+1+MV_decode(y,x,1) : (y-1)*8+8+MV_decode(y,x,1), (x-1)*8+1+MV_decode(y,x,2) : (x-1)*8+8+MV_decode(y,x,2), : );
            end
        end
        image_reconstructed( :, :, :, i+1 ) = image_reconstructed_temp + error_decode;
        image_predicted = image_predicted_temp;

        MSE(i+1) = calcMSE( image, image_reconstructed( :, :, :, i+1), dimension, height, width );
        PSNR(i+1) = calcPSNR( MSE(i+1) );

    end
    
    PSNR_video(j) = sum(PSNR)/21;
    bit_rate_video(j) = sum(bit_rate)/21
    
    
end

plot(bit_rate_still, PSNR_still, '-xb' );
hold on;
plot(bit_rate_video, PSNR_video, '-xr' );


