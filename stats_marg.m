function [ pmf ]= stats_marg( image )

counter = hist( image( : ), 0 : 255 );
pmf =  counter / sum( counter ) + eps;

end