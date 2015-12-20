function [ intensity_values ] = changeIDCT8x8( DCT_coefficients )

intensity_values = idct( idct(DCT_coefficients)' )';

end