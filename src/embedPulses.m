cc()
addpath('src')
load('dat/NM91_pulses', 'pulseShapes')
%% normalize
disp('normalizing pulses...')
pulseShapesNorm = normalizePulses(pulseShapes);
disp('   done.')
save('res/NM91_pulsesNorm', 'pulseShapesNorm')

%% embed using T - S N E
disp('tSNE embedding pulses (may take a while)...')
output_dims = 2;
initial_dims = 30;   % tsne default
perplexity = 30;     % tsne default
verbosity = 0;       % silence tsne
tSNE = tsne(double(pulseShapesNorm), [], output_dims, initial_dims, perplexity, verbosity);
scatter(tSNE(:,1), tSNE(:,2), '.k')
axis('square','tight')
xlabel('tSNE dim 1')
ylabel('tSNE dim 2')
disp('   done.')
save('res/NM91_tsne', 'tSNE')
