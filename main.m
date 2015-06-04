%% Initialization
frames = 50;
 
camera = imaq.VideoDevice('winvideo', 2, 'MJPG_1280x720', ... % Acquire input video stream
    'ROI', [1 1 1280 720], ...
    'ReturnedColorSpace', 'rgb');

camInfo = imaqhwinfo(camera); % Acquire input video property
 
display = vision.VideoPlayer('Name', 'Chariotometer', ... % Output video player
    'Position', [100 50 camInfo.MaxWidth+20 camInfo.MaxHeight+25]);
 
chariotCoordinatesText = vision.TextInserter('Text', '+ X:%4d, Y:%4d', ... % set text for centroid
    'LocationSource', 'Input port', ...
    'Color', [1 1 0], ... // yellow text
    'FontSize', 12);

i = 0; % Frame number initialization

%% Processing Loop
while(i < frames)
    frame = step(camera); % Acquire single frame
    
    coordinates = findChariot(frame);
    
    frame = step(chariotCoordinatesText, frame, coordinates, coordinates);
    
    step(display, frame); % Output to display
    
    i = i + 1;
end
 
%% Clearing Memory
release(display); % Release all memory and buffer used

release(camera);
 
clear all;
 
clc;