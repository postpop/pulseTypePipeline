function [Fpeak, amp, F] = getPulseFreq(pulses, threshold)
% [Fpeak, amp, F] = getPulseFreq(pulses, threshold=1/e)
if ~exist('threshold','var')
   threshold = 1/exp(1);
end
fftLen = 2000;
Fs = 10000;
tmp = abs(fft(pulses, fftLen))';
amp = tmp(:,1:fftLen/2);
F = (1:ceil(fftLen/2)) * Fs/fftLen;
Fpeak = centerOfMass(F, amp, threshold)';
