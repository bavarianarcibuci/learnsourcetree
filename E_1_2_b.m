w1 = [ 1, 2, 1; 2, 4, 2; 1, 2, 1 ];

subplot( 1, 2, 1 )
freq_resp = abs( fft2( w1 ) );
mesh( freq_resp );
title( 'fft2' );


subplot( 1,2,2 )
freq_resp_shift = abs( fftshift( fft2( w1 ) ) );
mesh( freq_resp_shift );
title( 'fftshift' );