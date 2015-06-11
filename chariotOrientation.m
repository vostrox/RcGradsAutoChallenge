function [out] = chariotOrientation(chariotX, chariotY, greenX, greenY, blueX, blueY)
    greenAngle = 0;
    blueAngle = 0;
    orientation = 0;

    %calculate green angle relative to centroid
    %Top right
    if ((greenX > chariotX) && (greenY > chariotY))
        greenAngle = atand((greenX - chariotX) / (greenY - chariotY));
    %Bottom right
    elseif ((greenX > chariotX) && (greenY < chariotY))
        greenAngle = atand((greenX - chariotX) / (greenY - chariotY)) + 90;
    %Bottom left
    elseif ((greenX < chariotX) && (greenY < chariotY))
        greenAngle = atand((greenX - chariotX) / (greenY - chariotY)) + 180;
    %Top left
    elseif ((greenX < chariotX) && (greenY > chariotY))
        greenAngle = atand((greenY - chariotY) / (greenX - chariotX)) + 270;
    end
      
    
    %calculate blue angle relative to centroid
    %Top right
    if ((blueX > chariotX) && (blueY > chariotY))
        blueAngle = atand((blueX - chariotX) / (blueY - chariotY));
        %get opposite value of blueAngle for orientation
        blueAngle = blueAngle - 180;
    %Bottom right
    elseif ((blueX > chariotX) && (blueY < chariotY))
        blueAngle = atand((blueX - chariotX) / (blueY - chariotY)) + 90;
        %get opposite value of blueAngle for orientation
        blueAngle = blueAngle - 180;
    %Bottom left
    elseif ((blueX < chariotX) && (blueY < chariotY))
        blueAngle = atand((blueX - chariotX) / (blueY - chariotY)) + 180;
        %get opposite value of blueAngle for orientation
        blueAngle = blueAngle + 180;
    %Top left
    elseif ((blueX < chariotX) && (blueY > chariotY))
        blueAngle = atand((blueY - chariotY) / (blueX - chariotX)) + 270;
        %get opposite value of blueAngle for orientation
        blueAngle = blueAngle + 180;
    end
    
    %calculate orientation
    orientation = (greenAngle + blueAngle) / 2;
    
    out = orientation;
end

