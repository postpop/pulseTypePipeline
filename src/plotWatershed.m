cc()
load('res/NM91_clustering')
load('res/NM91_tsne')
colormap(parula(256));
%%
clf
subplot(121)
scatter(tSNE(:,1),tSNE(:,2),'.k')
hold on
plot(XX{1}(boundaryX),XX{2}(boundaryY),'.r')

subplot(122)
imagesc(XX{1}, XX{2}, Z0)
hold on
plot(XX{1}(boundaryX),XX{2}(boundaryY),'.r')

axis(gcas, 'square', 'tight', 'off', 'xy')
figexp('fig/plotWatershed', 0.7, 0.4)

