function [out] = chariotOrientation(chariotX, chariotY, greenX, greenY, blueX, blueY)
    greenAngle = 0;
    blueAngle = 0;
    
    %convert to doubles
    chariotX = double(chariotX);
    chariotY = double(chariotY);
    greenX = double(greenX);
    greenY = double(greenY);
    blueX = double(blueX);
    blueY = double(blueY);
    
    
    %calculate green angle relative to centroid
    %Top left
    if ((greenX < chariotX) && (greenY < chariotY))
        greenAngle = atand((chariotY - greenY) / (chariotX - greenX)) + 270;
    %Directly above chariot
    elseif ((greenX == chariotX) && (greenY < chariotY))
        greenAngle = 0;
    %Top right
    elseif ((greenX > chariotX) && (greenY < chariotY))
        greenAngle = atand((greenX - chariotX) / (chariotY - greenY));
    %Directly right of chariot
    elseif ((greenX > chariotX) && (greenY == chariotY))
        greenAngle = 90;
    %Bottom left
    elseif ((greenX < chariotX) && (greenY > chariotY))
        greenAngle = atand((chariotX - greenX) / (greenY - chariotY)) + 180;
    %Directly below chariot
    elseif ((greenX == chariotX) && (greenY > chariotY))
        greenAngle = 180;
    %Bottom right
    elseif ((greenX > chariotX) && (greenY > chariotY))
        greenAngle = atand((greenY - chariotY) / (greenX - chariotX)) + 90;
    %Directly left of chariot
    elseif ((greenX < chariotX) && (greenY == chariotY))
        greenAngle = 270;
    end
    %Ensure angle circulates past zero to prevent angles more than 360
    if (greenAngle >= 360)
        greenAngle = greenAngle - 360;
    end
    
    %calculate blue angle relative to centroid (note: blue angle should
    %   come out the opposite way round to align with green angle
    %Top left
    if ((blueX < chariotX) && (blueY < chariotY))
        blueAngle = atand((chariotY - blueY) / (chariotX - blueX)) + 270;
    %Directly above chariot
    elseif ((blueX == chariotX) && (blueY < chariotY))
        blueAngle = 0;
    %Top right
    elseif ((blueX > chariotX) && (blueY < chariotY))
        blueAngle = atand((blueX - chariotX) / (chariotY - blueY));
    %Directly right of chariot
    elseif ((blueX > chariotX) && (blueY == chariotY))
        blueAngle = 90;
    %Bottom left
    elseif ((blueX < chariotX) && (blueY > chariotY))
        blueAngle = atand((chariotX - blueX) / (blueY - chariotY)) + 180;
    %Directly below chariot
    elseif ((blueX == chariotX) && (blueY > chariotY))
        blueAngle = 180;
    %Bottom right
    elseif ((blueX > chariotX) && (blueY > chariotY))
        blueAngle = atand((blueY - chariotY) / (blueX - chariotX)) + 90;
    %Directly left of chariot
    elseif ((blueX < chariotX) && (blueY == chariotY))
        blueAngle = 270;
    end
    %Add 180 to get chariot orientation according to mirrored blue angle
    blueAngle = blueAngle + 180;
    %Ensure angle circulates past zero to prevent angles more than 360
    if (blueAngle >= 360)
        blueAngle = blueAngle - 360;
    end
    
    %fprintf('Green: %d\n', greenAngle);
    %fprintf('Blue: %d\n', blueAngle);
    
    %if angles are in the top half, mirror them, average them, then mirror the average
    if (((greenAngle < 45) || (greenAngle > 315)) && ((blueAngle < 45) || (blueAngle > 315)))
        greenAngle = greenAngle + 180;
        blueAngle = blueAngle + 180;
        
        if (greenAngle >= 360)
            greenAngle = greenAngle - 360;
        end
        if (blueAngle >= 360)
            blueAngle = blueAngle - 360;
        end
        
        orientation = (greenAngle + blueAngle) / 2;
        
        orientation = orientation + 180;
        
        if (orientation >= 360)
            orientation = orientation - 360;
        end
    else
        orientation = (greenAngle + blueAngle) / 2;
    end
    
    %fprintf('Orientation: %d\n', orientation);

    %format into 0 to 180 / 0 to -180
    %if (orientation > 180)
    %    orientation = 360 - orientation;
    %    orientation = orientation * -1;
    %end
    
    out = int16(orientation);
end
