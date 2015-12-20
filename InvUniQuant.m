function [ image_reconstructed ] = InvUniQuant( image_quantized, M )

image_reconstructed = ( image_quantized .* ( 1 / 2^M ) + 1 / 2^(M+1) ) * 256;

end