function pulses = normalizePulses(pulses, signWindow, smoothWindow)
% pulses = normalizePulses(pulses, signWindow=[10 0], smoothWindow=15)
% normalizes pulses by 1. dividing by norm, 2. aliging to peak energy (envelope), and 3. flipping sign
%
% ARGS
%  pulses - Npulses x Nsamples matrix of pulse shapes
%  signWindow   - n samples (preceding peak) to use for sign flipping
%  smoothWindow - n samples with which to smooth pulse for RMS envelope estimation
% RETURNS
%  normalized pulses

if ~exist('signWindow','var') || isempty(signWindow)
   signWindow = [10 0];
end

if ~exist('smoothWindow', 'var') || isempty(smoothWindow)
   smoothWindow = 15;
end

pulses = double(pulses);
[nPulses, pulseDur] = size(pulses);
%% Center on max power and flip if negative lobe to left of max power

for ii = 1:nPulses
   oldPulse = pulses(ii,:);
   oldPulse = oldPulse./norm(oldPulse);                     % scale to unit norm
   [~,mIdx] = max(smooth(oldPulse.^2, smoothWindow));       % get max power then center on this
   lPad = pulseDur - mIdx;  %i.e. ((total_length/2) - C)    
   rPad = 2*pulseDur - pulseDur - lPad;
   newPulse = [zeros(1,lPad) oldPulse zeros(1, rPad)];
   if mean(newPulse(pulseDur-signWindow(1):pulseDur-signWindow(2)))<0
      newPulse = -newPulse;                                 % flip pulse if it starts neg.
   end
   pulses(ii,:) = newPulse(floor(pulseDur/2)+(1:pulseDur)); % cut normalized pulse to original duration
end
