function [XX, Z, bw] = mvks(data, N)
% [XX, Z, bw] = mvks(data, N)
% simple wrapper around mvksdensity
% generates X/Y bins from N (number of bins) and data limits
for dim = 1:size(data,2)
   X{dim} = linspace(min(data(:,dim)), max(data(:,dim)), N);
end
[xx, yy] = meshgrid(X{1}, X{2});
XX = [xx(:) yy(:)];

[Z, ~, bw] = mvksdensity(data, XX);
Z = reshape(Z,[N N]);
