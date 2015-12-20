function [ representatives ] = LloydMax3( image, epsilon )

[height width dimension]=size( image );

M = 3;
D_previous = 1;
D_next = 1001;
index = zeros( size( image ) );
error= zeros( size( image ) );

for m = 1 : 2^M
    representatives(m) = ( ( m-1 ) * ( 1 / 2^M ) + 1 / 2^(M+1) ) * 256; %representatives
end

quan_table = zeros( length(representatives), 2 ); %quantization table initialization

while abs( D_next - D_previous ) / D_next >= epsilon
    
    for i=1:height
        for j=1:width
            for k=1:dimension
                [ error(i,j,k), index(i,j,k) ] = min( abs( image(i,j,k) - representatives ) );
                quan_table( index(i,j,k), 1 ) = quan_table( index(i,j,k), 1) + image(i,j,k);
                quan_table( index(i,j,k), 2 ) = quan_table( index(i,j,k), 2 ) + 1;
            end
        end
    end
    
    square_error = error.^2;
    D_previous = D_next;
    D_next = sum( square_error(:) );
    
    representatives = quan_table( :, 1 ) ./ quan_table( :, 2 );
end

end


