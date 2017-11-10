cc()
load('dat/NM91_pulses', 'pulseShapes')
load('res/NM91_pulsesNorm', 'pulseShapesNorm')
load('res/NM91_clustering', 'Gw')
cols = lines(2);
subIdx = 1:20:size(pulseShapes,1);
%%
clf
subplot(311)
plot(pulseShapes(subIdx,:)', 'k')
title('raw pulses')
scalebar(200, -0.3, 50, '5ms',10)
subplot(312)
plot(pulseShapesNorm(subIdx,:)', 'k')
title('normalized pulses')

subplot(313)
plot(pulseShapesNorm(subIdx(Gw(subIdx)==1),:)', 'Color', cols(1,:))
hold on
plot(pulseShapesNorm(subIdx(Gw(subIdx)==2),:)', 'Color', cols(2,:))
title('clustered pulses')

axis(gcas, 'tight', 'off')
figexp('fig/plotPulses', 0.4,.7)
