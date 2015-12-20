function [ image_prefiltered ] = prefilterlowpass2d( image, w )

%image = double( imread( 'data/images/satpic1.bmp' ) );

%w = [1, 2, 1; 2, 4, 2; 1, 2, 1] / 16;

for i = 1:3
    image_prefiltered( :, :, i ) = conv2( image( :, :, i ), w, 'same');     %filter the image
end

 
imshow( image_prefiltered / 256 );     %convert the filtered image to double with value range from 0 to 1

end