function [out] = insertBorders(image)
    % get the height of image, as the y axis increments from the top to the bottom
    [height, width, dim] = size(image);
    
    %border values
    left = 10;
    right = 10;
    top = 10;
    bottom = 10;
    slalomTop = 100;
    slalomBottom = 100;
    slalomEdge = 100;
    
    % insert left border
    % use left
    image(1:height, 1:left, :) = 0;
    
    % insert right border
    % use right
    image(1:height, width-right:width, :) = 0;
    
    % insert top border
    % use top
    % remember that the y axis increments from the top to the bottom
    image(1:top, 1:width, :) = 0;
    
    % insert bottom border
    % use bottom
    % remember that the y axis increments from the top to the bottom
    image(height-bottom:height, 1:width, :) = 0;
    
    % insert rectangle above slalom
    % use slalomTop and slalomEdge
    % remember that the y axis increments from the top to the bottom
    image(1:slalomTop, width-slalomEdge:width, :) = 0;
    
    % insert rectangle below slalom
    % use slalomBottom and slalomEdge
    % remember that the y axis increments from the top to the bottom
    image(height-slalomBottom:height, width-slalomEdge:width, :) = 0;
    
    out = image;
end