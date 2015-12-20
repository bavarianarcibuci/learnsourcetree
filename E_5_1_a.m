clc
clear

image_fore0020 = double(imread('data/images/foreman20_40_RGB/foreman0020.bmp'));
[ height, width, dimension ] = size( image_fore0020 );
code_fore0020 = IntraEncode( image_fore0020, 1 );

pmf = hist( code_fore0020, min(code_fore0020) : max(code_fore0020) );
pmf = pmf / sum( pmf );

%build huffman code
[BinaryTree, HuffCode, BinCode, Codelengths ] = buildHuffman( pmf );

%encode
bytestream = enc_huffman_new( code_fore0020 - min(code_fore0020) + 1, BinCode, Codelengths );
bit_rate = length( bytestream ) *8 / ( height * width )

%decode
code_fore0020_decode = dec_huffman_new ( bytestream, BinaryTree, length(code_fore0020) ) + min(code_fore0020) - 1;

image_fore0020_reconstructed = IntraDecode( code_fore0020_decode, height, width, dimension, 1 );

imshow(uint8(image_fore0020))
figure
imshow(uint8(image_fore0020_reconstructed))

MSE = calcMSE( image_fore0020, image_fore0020_reconstructed, dimension, height, width );
PSNR = calcPSNR( MSE );


