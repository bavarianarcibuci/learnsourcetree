function [ code ] = IntraEncode( image, alpha )

image_YCbCr = ictRGB2YCbCr( image );

[ height, width, dimension ] = size( image_YCbCr );
code=[];
index=1;

for k = 1 : dimension
    for i = 1 : height/8
        for j = 1 : width/8
            block = image_YCbCr( (i-1)*8+1 : (i-1)*8+8, (j-1)*8+1 : (j-1)*8+8, k ); %partition image into blocks
            code_temp = ZeroRunEnc( ZigZag8x8( Quant8x8( DCT8x8(block), k, alpha ) ) );
            code( index : index+length(code_temp)-1 ) = code_temp;
            index = index + length(code_temp);
        end
    end
end

end