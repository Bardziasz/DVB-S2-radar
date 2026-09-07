parameters;
close all;
%% signal generation, every wave(i) is a signal with set of its own parameters

for k=1:10
    wave(k).wave_tx = wave(k).param(data); % generate the signall
    wave(k).wave_tx=wave(k).wave_tx/max(abs(wave(k).wave_tx));
    wave(k).wave_tx=wave(k).wave_tx - mean(wave(k).wave_tx);
end
sps = wave(1).param.SamplesPerSymbol; %sps is the same for every wave(k)



%% channel

if(1)  
    echoes=[0.1*exp(j*180/180*pi),0.01*exp(j*60/180*pi),0.1*exp(j*90/180*pi),0.1*exp(j*160/180*pi)]; %echoes
    doppler=[40e3, 7e3, 5e3, 2e3]; %doppler frequencies calculated from objects with velocities ranging 1000-400 km/h with carrier frequency of 10.2 Ghz, (nośna do liczenia dopplera wzięta z artykułu)
    delays=[0, 100, 100, 100];
    x=wave(1).wave_tx;
    fs=wave(1).Fsamp;
    N=length(x);
    t=(0:N-1)'/fs;

    for k=1:length(echoes)
        y1=circshift(wave(1).wave_tx,delays(k));
        x=x+y1*echoes(k).*exp(j*2*pi*t*doppler(k)); %adding echoes and doppler
        
    end
    if(1)
        y=awgn(x,20); % awgn
    else
        y=x;
    end
    wave(1).wave_rx=y;
    clear x y

end


[afmag,delay,doppler]=ambgfun()

%% constellation
if(0)
    txConst = comm.ConstellationDiagram(Title = "constellation", ...
    ShowReferenceConstellation = false, ...
    SamplesPerSymbol = sps, ...
    NumInputPorts=2, ...
    ChannelNames = {"wave_tx ","wave_rx"});
    plHeaderLen=90*sps;
    txConst(wave(1).wave_tx(plHeaderLen+1:end),wave(1).wave_rx(plHeaderLen+1:end));
end

% spectrum FFT
if(1)
    figure(1);
    fs=wave(1).Fsamp;
    N=length(wave(1).wave_rx);
    RX = fftshift(fft(wave(1).wave_rx,N));
    TX = fftshift(fft(wave(1).wave_tx,N));
    f = (-N/2:N/2-1)*fs/N;
    subplot(2,1,1);
    plot(f,20*log10(abs(RX)/N),'b',f,20*log10(abs(TX)/N));
    grid on
    xlabel('Frequency [Hz]')
    ylabel('Magnitue [dB]')
    xlim([-1.5e8 1.5e8])
    ylim([-140 -30])
    legend('RX','TX')
    subplot(2,1,2);
    plot(f,20*log10(abs(RX)/N),f,20*log10(abs(TX)/N))
    xlabel('Frequency [Hz] (doppler range)')
    ylabel('Magnitue [dB]')
    xlim([1e3 20e3])
    ylim([-140 -30])
    legend('RX','TX')
end
%% spectrum scope
if(1)
    specAn = spectrumAnalyzer(SampleRate = wave(1).Fsamp, ...
        ChannelNames = ["wave_tx " "wave_rx" ], ...
        ShowLegend = true);
    specAn([wave(1).wave_tx,wave(1).wave_rx]);
end






