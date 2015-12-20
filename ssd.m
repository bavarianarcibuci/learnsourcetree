function [ssd,dy,dx] = ssd( block, block_ref)

[ height_ref width_ref ] = size(block_ref);
[ height width ] =size(block);

difference = zeros(8,8);
ssd=999999999;

    for i = 1 : height_ref-height+1
        for j = 1 : width_ref-width+1
            difference = block_ref( i:i+height-1, j:j+width-1 ) - block;
            temp = sum( (difference).^2 );
            if ssd > temp
                ssd = temp;
                dy = i - (height_ref-height+2)/2;
                dx = j - (width_ref-width+2)/2;
            end
        end
    end
end