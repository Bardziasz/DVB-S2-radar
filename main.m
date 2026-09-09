close all;
clear all;
parameters;

% ----------------------------------------------------------------------------------------
%% 1 signal generation, every wave(i) is a signal with set of its own parameters

for k=1:wave_num
    wave(k).wave_tx = wave(k).param(data); % generate the signall\
    wave(k).wave_tx=wave(k).wave_tx - mean(wave(k).wave_tx);
    wave(k).wave_tx=wave(k).wave_tx/max(abs(wave(k).wave_tx)); % normalisation 
    
end
sps = wave(1).param.SamplesPerSymbol; %sps is the same for every wave(k)

% ----------------------------------------------------------------------------------------
%% 2 accumulation of generated pulses wave_num times
wave_tx=[];
if(1)
    for k=1:wave_num
        wave_tx=[wave_tx; wave(k).wave_tx]; %summing wave(k).wave_tx k times to wave_tx
    end
end

% ----------------------------------------------------------------------------------------
%% 3 Channel surveillance antenna

if(1)
    A=target.attenuation_linear;
    fd=target.doppler;
    echoes=[1*exp(j*180/180*pi),1*exp(j*60/180*pi),1*exp(j*90/180*pi)]; %echoes
    delays=[350, 300, 200]; % delays in N of samples

    x=wave_tx;
    N=length(x);
    t=(0:N-1)'/fs;
    x=[x; zeros(max(delays),1)]; %padding 
   
    for k=1:length(echoes)
        y=wave_tx;
        y=y*A(k)*echoes(k).*exp(j*2*pi*t*fd(k)); % A (attenuation), echoes, fd (doppler)
        y=[zeros(delays(k), 1); y]; %delay padding
        y=[y; zeros(max(delays)-delays(k),1)]; % matching array sizes for x and y
        x=x+y;
    end
    if(1)
        x=awgn(x,0); % awgn
    end
    wave_sx=x;
    clear x y 

end

% ----------------------------------------------------------------------------------------
%% 3 Channel reference antenna

if(1)
    x=wave_tx;

    if(1)
        x=awgn(wave_tx,0);
    end
    wave_rx=x;
    clear x y 

end
% ----------------------------------------------------------------------------------------
%%  results

if(1)
     [ RVM, r, v, r_int, v_int ] = caf_fast( wave_rx, wave_sx, fs, 0 );
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
    fs=fs;
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
    specAn = spectrumAnalyzer(SampleRate = fs, ...
        ChannelNames = ["wave_tx " "wave_rx" ], ...
        ShowLegend = true);
    specAn([wave_tx,wave_rx]);
end






