function [ entropy ] = calc_entropy( pmf )

entropy = -sum( pmf .* log2( pmf ) );

end

