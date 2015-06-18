testImage = imread('testImage.png');

rectSize = 200;

%% Initialization
display = vision.VideoPlayer('Name', 'Chariotometer', ... % Output video player
    'Position', [0 0 1280 720]);
 
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
orientationText = vision.TextInserter('Text', 'Orientation: %3d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [255 255 0], ... // yellow text
    'FontSize', 12);

frame = testImage;

chariotCoordinates = findChariot(frame);
gOrbCoordinates = findGreenOrb(frame, chariotCoordinates(1), chariotCoordinates(2), rectSize);
bOrbCoordinates = findBlueOrb(frame, chariotCoordinates(1), chariotCoordinates(2), rectSize);
orientation = chariotOrientation(chariotCoordinates(1), chariotCoordinates(2), gOrbCoordinates(1), gOrbCoordinates(2), bOrbCoordinates(1), bOrbCoordinates(2));

frame = step(chariotCoordinatesText, frame, chariotCoordinates, chariotCoordinates-6);
frame = step(gOrbCoordinatesText, frame, gOrbCoordinates, gOrbCoordinates-6);
frame = step(bOrbCoordinatesText, frame, bOrbCoordinates, bOrbCoordinates-6);
frame(1:20,1:103,:) = 0; % draw a black box in the top left corner
frame = step(orientationText, frame, orientation, int32([5 3]));

step(display, frame); % Output to display