cc()
load('res/NM91_clustering')
load('res/NM91_tsne') 
load('res/NM91_pulsesNorm')
centroidsPre = grpstats(pulseShapesNorm, Gpre);
centroids = grpstats(pulseShapesNorm, Gw);
centroidTSNEpre = grpstats(tSNE, Gpre);
centroidTSNE = grpstats(tSNE, Gw);
cmap = lines(max(Gpre)+2);

%%
clf
subplot(1,6,1:2)
gscatter(tSNE(:,1), tSNE(:,2), Gpre, cmap(3:end,:), '.', [],[],'off')
hold on
for cnt = 1:size(centroidsPre,1)
   plot( (1:size(centroidsPre,2)-120)/5 + centroidTSNEpre(cnt,1)-12, 50*centroidsPre(cnt,60:end-60-1)+centroidTSNEpre(cnt,2), 'k','LineWidth', 1.5)
end
hold off
axis(gca, 'square', 'tight', 'off')
title('watershed')

colors = lines(2);
subplot(1,6,3)
Z = linkage(centroidsPre);
colormap(lines(2))
h = dendrogram(Z, 'Orientation','left', 'Reorder',argsort(Gc));
set(h, 'LineWidth',1.5, 'Color', 'k')
axis('off')
set(gca, 'YLim', [0.5 max(Gpre)+0.5])

subplot(1,6,4)
plot(bsxfun(@plus, centroidsPre(argsort(Gc),:)'*1.5, (1:max(Gpre))), 'LineWidth',1.0)
colorLines(colors(sort(Gc, 'descend'),:))
set(gca, 'YLim', [0.5 max(Gpre)+0.5])
axis('off')

subplot(1,6,5:6)
gscatter(tSNE(:,1), tSNE(:,2), Gw, cmap([1 2],:),'.',[],[],'off')
hold on
plot( (1:size(centroids,2)-120)/5+centroidTSNE(1,1)-12, 50*centroids(1,60:end-60-1)+centroidTSNE(1,2), 'k','LineWidth', 2)
plot( (1:size(centroids,2)-120)/5+centroidTSNE(2,1)-12,  50*centroids(2,60:end-60-1)+centroidTSNE(2,2), 'k','LineWidth', 2)
axis('tight', 'off', 'square')
title('consolidated')

figexp('fig/plotClusterConsolidation', 1.0, 0.35)

