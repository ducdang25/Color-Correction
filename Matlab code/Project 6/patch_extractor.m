clc; close all; clear all;
rawImg = imread('frame_300.png');
sc_p = 70; % col size of each patch (in pixels)
sr_p = 70; % row size of each patch (in pixels)
image(rawImg);

% 1st patch: 69 83 70 70
rec1 = [50 100 69 69];
patch1 = imcrop(rawImg, rec1);
figure; imshow(patch1);
% 2nd patch: 225 75 69 69
rec2 = [225 100 69 69];
patch2 = imcrop(rawImg, rec2);
figure; imshow(patch2);
% 3rd patch: 425 75 69 69
rec3 = [350 100 69 69];
patch3 = imcrop(rawImg, rec3);
figure; imshow(patch3);
% 4th patch: 69 83 70 70
rec4 = [525 100 69 69];
patch4 = imcrop(rawImg, rec4);
figure; imshow(patch4);
% 5th patch: 69 83 70 70
rec5 = [675 100 69 69];
patch5 = imcrop(rawImg, rec5);
figure; imshow(patch5);
% 6th patch: 69 83 70 70
rec6 = [825 100 69 69];
patch6 = imcrop(rawImg, rec6);
figure; imshow(patch6);


% 7st patch: 69 83 70 70
rec7 = [50 250 69 69];
patch7 = imcrop(rawImg, rec7);
figure; imshow(patch7);
% 8nd patch: 225 75 69 69
rec8 = [225 250 69 69];
patch8 = imcrop(rawImg, rec8);
figure; imshow(patch8);
% 9rd patch: 425 75 69 69
rec9 = [350 250 69 69];
patch9 = imcrop(rawImg, rec9);
figure; imshow(patch9);
% 10th patch: 69 83 70 70
rec10 = [525 250 69 69];
patch10 = imcrop(rawImg, rec10);
figure; imshow(patch10);
% 11th patch: 69 83 70 70
rec11 = [675 250 69 69];
patch11 = imcrop(rawImg, rec11);
figure; imshow(patch11);
% 12th patch: 69 83 70 70
rec12 = [825 250 69 69];
patch12 = imcrop(rawImg, rec12);
figure; imshow(patch12);



% 13st patch: 69 83 70 70
rec13 = [50 400 69 69];
patch13 = imcrop(rawImg, rec13);
figure; imshow(patch13);
% 14nd patch: 225 75 69 69
rec14 = [225 400 69 69];
patch14 = imcrop(rawImg, rec14);
figure; imshow(patch14);
% 15nd patch: 225 75 69 69
rec15 = [350 400 69 69];
patch15 = imcrop(rawImg, rec15);
figure; imshow(patch15);
% 16rd patch: 425 75 69 69
rec16 = [525 400 69 69];
patch16 = imcrop(rawImg, rec16);
figure; imshow(patch16);
% 17th patch: 69 83 70 70
rec17 = [675 400 69 69];
patch17 = imcrop(rawImg, rec17);
figure; imshow(patch17);
% 18th patch: 69 83 70 70
rec18 = [825 400 69 69];
patch18 = imcrop(rawImg, rec18);
figure; imshow(patch18);


% 19th patch: 69 83 70 70
rec19 = [50 550 69 69];
patch19 = imcrop(rawImg, rec19);
figure; imshow(patch19);
% 20th patch: 69 83 70 70
rec20 = [225 550 69 69];
patch20 = imcrop(rawImg, rec20);
figure; imshow(patch20);
% 21th patch: 69 83 70 70
rec21 = [350 550 69 69];
patch21 = imcrop(rawImg, rec21);
figure; imshow(patch21);
% 22th patch: 69 83 70 70
rec22 = [525 550 69 69];
patch22 = imcrop(rawImg, rec22);
figure; imshow(patch22);
% 23th patch: 69 83 70 70
rec23 = [675 575 69 69];
patch23 = imcrop(rawImg, rec23);
figure; imshow(patch23);
% 24th patch: 69 83 70 70
rec24 = [825 575 69 69];
patch24 = imcrop(rawImg, rec24);
figure; imshow(patch24);



