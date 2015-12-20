clc
clear

image_lena_small = double(imread('data/images/lena_small.tif'));
code_lena_small = IntraEncode(image_lena_small, 1);

pmf = hist( code_lena_small, min(code_lena_small) : max(code_lena_small)+100 );
pmf = pmf / sum( pmf );

%build huffman code from lena_small
[BinaryTree, HuffCode, BinCode, Codelengths ] = buildHuffman( pmf );

image_lena = double(imread('data/images/lena.tif'));
[ height, width, dimension ] = size( image_lena );
code_lena = IntraEncode( image_lena, 1 );

%encode
bytestream = enc_huffman_new( code_lena - min(code_lena) + 1, BinCode, Codelengths );
bit_rate = length( bytestream ) *8 / ( height * width )

%decode
code_lena_decode = dec_huffman_new ( bytestream, BinaryTree, length( code_lena ) ) + min(code_lena) - 1;

image_lena_reconstructed = IntraDecode( code_lena_decode, height, width, dimension, 1 );


MSE = calcMSE(image_lena, image_lena_reconstructed, dimension, height, width );
PSNR = calcPSNR( MSE );


