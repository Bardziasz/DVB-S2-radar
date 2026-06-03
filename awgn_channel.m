function [waveform_noise] = awgn_channel(waveform_clean)

snr=20;
waveform_noise=awgn(waveform_clean,snr);


end



