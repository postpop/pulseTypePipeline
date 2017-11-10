function com = centerOfMass(x,y, threshold)
% computes center of mass
% USAGE: centerOfMass(x,y, threshold)

if nargin==2
   threshold =  0.5;
end
y = normalizeMax(y);
y = limit(y-threshold,0,inf);
com = x*normalizeSum(y)';
