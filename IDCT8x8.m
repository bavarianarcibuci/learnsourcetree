function [ intensity_values ] = IDCT8x8( DCT_coefficients )

intensity_values = idct( idct(DCT_coefficients)' )';

end