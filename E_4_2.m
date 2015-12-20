clc
clear
alpha = [0.1, 0.2, 0.3, 0.5, 0.8, 1, 2, 3, 4, 5];
MSE = zeros( 1, 10);
PSNR = zeros( 1, 10);
bit_rate = zeros(1, 10);

for i = 1 : 10
    
    image_lena_small = double(imread('data/images/lena_small.tif'));
    code_lena_small = IntraEncode(image_lena_small, alpha(i) );

    pmf = hist( code_lena_small, min(code_lena_small) : max(code_lena_small)+500 );
    pmf = pmf / sum( pmf );

    %build huffman code from lena_small
    [BinaryTree, HuffCode, BinCode, Codelengths ] = buildHuffman( pmf );

    image_lena = double(imread('data/images/lena.tif'));
    [ height, width, dimension ] = size( image_lena );
    code_lena = IntraEncode( image_lena, alpha(i) );

    %encode
    bytestream = enc_huffman_new( code_lena - min(code_lena) + 1, BinCode, Codelengths );
    bit_rate(i) = length( bytestream ) *8 / ( height * width );

    %decode
    code_lena_decode = dec_huffman_new ( bytestream, BinaryTree, length( code_lena ) ) + min(code_lena) - 1;

    image_lena_reconstructed = IntraDecode( code_lena_decode, height, width, dimension, alpha(i) );


    MSE(i) = calcMSE(image_lena, image_lena_reconstructed, dimension, height, width );
    PSNR(i) = calcPSNR( MSE(i) );

end

plot(bit_rate, PSNR, '-x' )


