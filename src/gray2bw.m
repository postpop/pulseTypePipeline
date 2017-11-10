function bwblobs = gray2bw(I, graythresh, areathresh)

%% extract those brightness blobs
slen = 3;
bwblobs = imextendedmax(I,graythresh); %bright blobs
bwblobs = imclose(bwblobs, ones(slen,slen));
bwblobs = imfill(bwblobs, 'holes');
bwblobs = bwareaopen(bwblobs,areathresh); %remove small objects