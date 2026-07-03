% currently not used

function [waveform_awgn] = awgn_channel(waveform_tx)

%%parameters
snr=30;
doppler=10e3;
phase=pi/20;
change=exp(1i*2*pi*doppler-1i*phase);
%% signal modification

waveform_awgn=awgn(waveform_tx,snr);
waveform_awgn=waveform_awgn.*change;


end



