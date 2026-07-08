%receiver without clear line of sight and with target
function [waveform_target_awgn] = receiver_with_target(waveform_awgn)

%% parameters   
doppler=10e3;
phase=pi/20;
target_noise=exp(1i*2*pi*doppler-1i*phase);


%% signal modification

waveform_target_awgn=wafeform_awgn.*target_noise;

end
