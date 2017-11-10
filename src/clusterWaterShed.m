function [Gw, Z, Z0, L, L0, X] = clusterWaterShed(data, NumberOfClusters, resolution)
% [Gw, Z, Z0, L, L0, X] = clusterWaterShed(data, NumberOfClusters, resolution)
%
% PARAMS:
% data             - N x ndims matrix
% NumberOfClusters - max number of clusters
% resolution       - bandwidth of the ksdensity estimate    

assert(~verLessThan('matlab','R2016a'), sprintf('matlab version is R%s. need at least R2016a. quitting...', version('-release')) )
ndims = size(data,2);
if ndims<3
   N = 100;
else
   N=50;
end
if ~exist('resolution','var')
   resolution = 0.9;
end

if length(N)==1
   N = repmat(N, [1, ndims]);
end
assert(ndims<4, 'to many dimensions. 1-3 allowed.')

%% 1. estimate PDF
for dim = 1:ndims
   X{dim} = linspace(min(data(:,dim)), max(data(:,dim)), N(dim));
end

switch ndims
   case 1
      [xx] = meshgrid(X{1});
      XX = xx(:);
      filtFun = @imgaussfilt;
   case 2
      [xx, yy] = meshgrid(X{1}, X{2});
       XX = [xx(:) yy(:)];
      filtFun = @imgaussfilt;
   case 3
      [xx, yy, zz] = meshgrid(X{1}, X{2}, X{3});
      XX = [xx(:) yy(:) zz(:)];
      filtFun = @imgaussfilt3;
end
[Z0a, ~, U0] = mvksdensity(data, XX);
Z0 = mvksdensity(data, XX, 'BandWidth', resolution*min(U0)*ones(ndims,1));
if all(Z0(:)==0)
   Z0 = Z0a;
end
Z0 = reshape(normalizeAbs(Z0),N);
%% 2. cluster into NumberOfClusters by smoothing the pdf
graythresh = 0.1;
areathresh = 20;
bwridge = edge(Z0,'canny'); %ridge should be better
bwgray = gray2bw( Z0, graythresh, areathresh );
bwblobs = bwgray & (~bwridge);

Iblobs = imimposemin(-(Z0), bwblobs);
L0 = watershed(Iblobs);

Z = Z0;
L = L0;
%%
filterWidth = 0;
while length(unique(L0(:)))>NumberOfClusters+1
   filterWidth = filterWidth+.2;
   Z = 1-filtFun(Z0, filterWidth);
   L0 = watershed(Z);
end
L = imclose(L0, ones(repmat(2, [1, ndims]))); % fill the ridge lines
%% label data
Gw = nan(size(data,1),1);
for pt = 1:size(data,1)
   switch ndims
      case 1
         Gw(pt) = L(findnearest(data(pt,1), X{1}));
      case 2
         Gw(pt) = L(findnearest(data(pt,2), X{2}), findnearest(data(pt,1), X{1}));
      case 3
         Gw(pt) = L(findnearest(data(pt,2), X{2}), findnearest(data(pt,1), X{1}), findnearest(data(pt,3), X{3}));
   end
end
