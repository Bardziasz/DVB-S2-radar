# DVB-S2 radar in matlab

## File structure
```
DVB-S2-radar/
├──main.m                       #main file        
├──parameters.m                 #simulation parameters
├──receiver.m                   #receiver function
├──awgn_channel.m               #awgn channel
├──dvbs2xLDPCParityMatrices.mat #file needed for generating signal

```

##
```
Steps for receiver:

RRC y
Gardner timing error detector w celu wykrycia momentu próbkowania y
Frame synchronization czyli gdzie zaczyna się PL frame y
course frquency synchronization zakłada offset częstotliwości na początku  n
fine frequency synchronization to samo tylko mniejsze n
phase synchronization obraca całą konstelację z powrotem n

odczyt PL header- odczyt właściwości y
demodulacja z prawdopodobieństwem y
dekodowanie ldpc- pierwszy check y
BCH - drugi check ys

bb header | czy transmisja była TS czy GS y
odtworzenie TS y

```
