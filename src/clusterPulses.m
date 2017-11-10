cc()
addpath('src')
load('res/NM91_pulsesNorm')
load('res/NM91_tsne')
%% pre-cluster
disp('watershed clustering pulses...')
[Gpre, Z, Z0, L, L0, XX] = clusterWaterShed(tSNE, 100);
[boundaryY,boundaryX] = find(L0==0);
disp('   done.')
%% merge clusters using hierarchical clustering of the pre-centroids
disp('consolidating clusters...')
centroidsPre = grpstats(pulseShapesNorm, Gpre);
Gc = clusterdata(centroidsPre,2);
Gw = mapVal(Gpre, unique(Gpre)', Gc');
% sort by "speed"
centroids = grpstats(pulseShapesNorm, Gw);
Gw = mapVal(Gw, argsort(argmax(centroids')), 1:size(centroids,1));
disp('   done.')
%%
save('res/NM91_clustering', 'Gpre', 'Gw', 'Gc','Z0', 'XX','boundaryY','boundaryX')
