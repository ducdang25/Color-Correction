nr = 1152;
nc = 2048;

color_patch = ones(nr*nc,3);

color_patch(:,1) = color_patch(:,1).*175;
color_patch(:,2) = color_patch(:,2).*54;
color_patch(:,3) = color_patch(:,3).*60;
color_patch = reshape(color_patch, nr, nc,3);
figure; imshow(color_patch/255);
imwrite(uint8(color_patch),'color_patch.jpg','jpg');