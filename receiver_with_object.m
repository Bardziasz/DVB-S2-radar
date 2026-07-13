%receiver without clear line of sight and with target
function [wave_awgn_target] = receiver_with_object(wave_awgn)

%% parameters   
doppler=10e3;
phase=pi/20;
target_noise=exp(1i*2*pi*doppler-1i*phase);


%% signal modification

wave_awgn_target=wave_awgn.*target_noise;

end
