
% function not used

function [data] = raw_data_generator(MinNumPackets)


numFrames = 1;                       % frame count
syncBits = [0 1 0 0 0 1 1 1]';       % synchronization bits 47 HEX
pktLen = 1496;                       % UP length without synchronization bits
numPkts = MinNumPackets*numFrames;
txRawPkts = randi([0 1],pktLen,numPkts);
txPkts = [repmat(syncBits,1,numPkts); txRawPkts]; % adding sync bits to every pktLen
data = txPkts(:);

end

% code with default generator, without using HelperDVBS2RxInputGenerate()

%data=raw_data_generator(cfgDVBS2.MinNumPackets); 
% waveform = cfgDVBS2(data); % generate the signal
% waveform_noise=awgn_channel(waveform); % awgn channel


% sps = cfgDVBS2.SamplesPerSymbol;
% constel = comm.ConstellationDiagram('ColorFading',true, ...
%     'ShowTrajectory',0, ...
%     'SamplesPerSymbol',sps, ...
%     'ShowReferenceConstellation',false, ...
%     'NumInputPorts',2,...
%     'XLimits',[-1.5 1.5], 'YLimits',[-1.5 1.5]);
% plHeaderLen = 90*sps;           % PL header length
% constel(waveform(plHeaderLen+1:end),waveform_noise(plHeaderLen+1:end));
% release(constel);
% 
% BW = 36e6;                 % Typical satellite channel bandwidth
% Fsym = BW/(1+cfgDVBS2.RolloffFactor);
% Fsamp = Fsym*sps;
% scope = spectrumAnalyzer('SampleRate',Fsamp);
% scope(waveform,waveform_noise)

