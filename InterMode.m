function [ ssd, MV, MV_index ] = InterMode( image_ref, image_cur)

[ height, width, dimension ] = size(image_ref);
image_ref_YCbCr = ictRGB2YCbCr( image_ref );
image_cur_YCbCr = ictRGB2YCbCr( image_cur );

ssd_temp = ones( height/8, width/8, 81);

image_ref_YCbCr = padarray( image_ref_YCbCr, [4,4], 1000000000, 'both'); %set a large number in order to tackle with board effect

for x = 1 : 8 : width
    for y = 1 : 8 : height
        block = image_cur_YCbCr( y:y+7, x:x+7, 1 );
         for dx = x : x+8
             for dy = y : y+8
                ssd_temp( (y-1)/8+1, (x-1)/8+1, (dx-x)*9+1+dy-y ) = sum( sum( sum( ( block - image_ref_YCbCr(dy:dy+7, dx:dx+7, 1) ).^2 ) ) );
             end
         end
    end
end

[ssd, MV_index] = min( ssd_temp, [], 3 );
[height_index, width_index] = size (MV_index);
MV = zeros(height_index, width_index, 2);

for i = 1 : width_index
    for j = 1 : height_index
        MV( j, i, 2 ) = -5 + ceil(MV_index(j,i)/9); %dx
        if mod(MV_index(j,i),9) == 0
            MV( j, i, 1 ) = 4;
        else
            MV( j, i, 1 ) = -5 + mod(MV_index(j,i),9); %dy
        end
    end
end

end
 