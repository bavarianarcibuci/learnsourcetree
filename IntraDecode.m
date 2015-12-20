function [ image_reconstructed ] = IntraDecode( code, height, width, dimension, alpha )

EOB_position = strfind( code, -9999 );
EOB_position = [0, EOB_position ];

index=1;
for k = 1 : dimension
    for i = 1 : height/8
        for j = 1 : width/8
            %block = code ( EOB_position( height/8*width/8*(k-1) + height/8*(i-1) + j ) + 1 : EOB_position( height/8*width/8*(k-1) + height/8*(i-1) + j+1 ) );
            block = code ( EOB_position( index ) + 1 : EOB_position( index+1 ) );
            index=index+1;
            block_reconstructed = IDCT8x8( DeQuant8x8( DeZigZag8x8( ZeroRunDec( block ) ), k, alpha ) );
            image_YCbCr_reconstructed( (i-1)*8+1 : (i-1)*8+8, (j-1)*8+1 : (j-1)*8+8, k ) = block_reconstructed;
        end
    end
end

image_reconstructed = ictYCbCr2RGB(image_YCbCr_reconstructed);


end