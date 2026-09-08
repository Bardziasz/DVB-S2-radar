close all;
clear all;
parameters;


%% signal generation, every wave(i) is a signal with set of its own parameters

for k=1:wave_num
    wave(k).wave_tx = wave(k).param(data); % generate the signall\
    wave(k).wave_tx=wave(k).wave_tx/max(abs(wave(k).wave_tx));
    wave(k).wave_tx=wave(k).wave_tx - mean(wave(k).wave_tx);
end
sps = wave(1).param.SamplesPerSymbol; %sps is the same for every wave(k)

wave_tx=[];
if(1)
    for k=1:wave_num
        wave_tx=[wave_tx; wave(k).wave_tx]; %summing wave(k).wave tx k times to wave_tx
    end
end

size(wave_tx)


%% channel

if(1)  
    echoes=[0.5*exp(j*180/180*pi),0.01*exp(j*60/180*pi),0.1*exp(j*90/180*pi),0.1*exp(j*160/180*pi)]; %echoes
    doppler=[0, 0, 3e3, 0]; %doppler frequencies calculated from objects with velocities ranging 1000-400 km/h with carrier frequency of 10.2 Ghz, (nośna do liczenia dopplera wzięta z artykułu)
    delays=[400, 300, 200, 100];
    x=wave_tx;
    fs=wave(1).Fsamp;
    x=[zeros( delays(3), 1); x]; %padding 
    N=length(x);
    y1=x;
    t=(0:N-1)'/fs;
    for k=1:length(echoes)
        
        y1=1*y1.*exp(j*2*pi*t*doppler(k)); %adding echoes and doppler  *echoes(k) +y1
        x=x+y1;
        
    end
    if(1)
        x=awgn(x,20); % awgn
    end
    wave_rx=x;
    clear x y

end



if(1)
     [ RVM, r, v, r_int, v_int ] = caf_fast( wave_tx, wave_rx, wave(1).Fsamp, 0 );
end


%% constellation
if(0)
    txConst = comm.ConstellationDiagram(Title = "constellation", ...
    ShowReferenceConstellation = false, ...
    SamplesPerSymbol = sps, ...
    NumInputPorts=2, ...
    ChannelNames = {"wave_tx ","wave_rx"});
    plHeaderLen=90*sps;
    txConst(wave_tx(plHeaderLen+1:end),wave_rx(plHeaderLen+1:end));
end

% spectrum FFT
if(1)
    figure(1);
    fs=wave(1).Fsamp;
    N=length(wave_rx);
    RX = fftshift(fft(wave_rx,N));
    TX = fftshift(fft(wave_tx,N));
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
    %plot(f,20*log10(abs(RX)/N),f,20*log10(abs(TX)/N))
    %xlabel('Frequency [Hz] (doppler range)')
    %ylabel('Magnitue [dB]')
    %%xlim([1e3 20e3])
    %ylim([-140 -30])
    %legend('RX','TX')
end
%% spectrum scope
if(0)
    specAn = spectrumAnalyzer(SampleRate = wave(1).Fsamp, ...
        ChannelNames = ["wave_tx " "wave_rx" ], ...
        ShowLegend = true);
    specAn([wave_tx,wave_rx]);
end






