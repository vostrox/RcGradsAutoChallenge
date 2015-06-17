testImage = imread('testImage.png');

%% Initialization
display = vision.VideoPlayer('Name', 'Chariotometer', ... % Output video player
    'Position', [100 50 1300 745]);
 
chariotCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [255 0 0], ... // red text
    'FontSize', 12);
gOrbCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [0 255 0], ... // green text
    'FontSize', 12);
bOrbCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [0 0 255], ... // blue text
    'FontSize', 12);
orientationText = vision.TextInserter('Text', 'Orientation: %4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [0 0 0], ... // black text
    'FontSize', 12);

frame = testImage;
    
chariotCoordinates = findChariot(frame);
gOrbCoordinates = findGreenOrb(frame);
bOrbCoordinates = findBlueOrb(frame);
orientation = chariotOrientation(chariotCoordinates(1), chariotCoordinates(2), gOrbCoordinates(1), gOrbCoordinates(2), bOrbCoordinates(1), bOrbCoordinates(2));

frame = step(chariotCoordinatesText, frame, chariotCoordinates, chariotCoordinates-6);
frame = step(gOrbCoordinatesText, frame, gOrbCoordinates, gOrbCoordinates-6);
frame = step(bOrbCoordinatesText, frame, bOrbCoordinates, bOrbCoordinates-6);
frame = step(orientationText, frame, orientation, chariotCoordinates-75);
    
step(display, frame); % Output to display