% currently not used

function [waveform_awgn] = awgn_channel(waveform_tx)

%% parameters
snr=30;



%% signal modification

waveform_awgn=awgn(waveform_tx,snr);

end



