parameters;

%% signal generation, every wave(i) is a signal with set of its own parameters

for k=1:10
    wave(k).wave_tx = wave(k).param(data); % generate the signall
end
sps = wave(1).param.SamplesPerSymbol; %sps is the same for every wave(k)

fs=wave(1).Fsamp;
fc=10.2e9; %nosna 10.2 GHz z artykułu

%% channel

if(1)  
    echoes=[0.01*exp(j*45/180*pi),0.01*exp(j*60/180*pi),0.01*exp(j*90/180*pi),0.01*exp(j*160/180*pi)]; %echoes
    doppler=[9e3, 7e3, 5e3, 2e3]; %doppler frequencies calculated from objects with velocities ranging 1000-400 km/h with carrier frequency of 10.2 Ghz, (nośna do liczenia dopplera wzięta z artykułu)
    delays=[3, 100, 100, 100];

    for k=1:length(echoes)
        x=wave(k).wave_tx;
        fs=wave(k).Fsamp;
        N=length(x);
        t=(0:N-1)'/fs;

        y1=circshift(x,delays(k));
        x=x+y1*echoes(k).*exp(j*2*pi*t*doppler(k)); %adding echoes and doppler
        y=awgn(x,20);
        wave(k).wave_rx=y;
    end
    clear x y
end


wave_tx=wave(1).wave_tx;
wave_rx=wave(1).wave_rx;



%% Transmitted and received signal constellation plot

txConst = comm.ConstellationDiagram(Title = "constellation", ...
ShowReferenceConstellation = false, ...
SamplesPerSymbol = sps, ...
NumInputPorts=2, ...
ChannelNames = {"wave_tx ","wave_rx"});
plHeaderLen=90*sps;
%txConst(wave(1).wave_tx(plHeaderLen+1:end),wave(1).wave_rx(plHeaderLen+1:end));



%% Transmitted and received signal spectrum visualization

specAn = spectrumAnalyzer(SampleRate = wave(1).Fsamp, ...
    ChannelNames = ["wave_tx " "wave_rx_target" ], ...
    ShowLegend = true);
%specAn([wave(1).wave_tx,wave(1).wave_rx]);








