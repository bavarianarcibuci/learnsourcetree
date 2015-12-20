function [ DCT_coefficients ] = changeDCT8x8( intensity_values )

DCT_coefficients = dct( dct(intensity_values)' )';

end