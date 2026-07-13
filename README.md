# DVB-S2 radar in matlab

## File structure
```
DVB-S2-radar/
├──main.m                       #main file - run to execute program        
├──parameters.m                 #simulation and waveforms parameters
├──receiver_with_los.m          #receiver with clear line of sight to the satellite
├──receiver_with_object.m       #receiver containing noise made by target
├──dvbs2xLDPCParityMatrices.mat #file needed for generating signal

```

##
```
Each wave(k) is a structure that consists of:
'wave_tx', [], ...           #transmitted wave
'wave_awgn', [], ...         #wave after awgn channel
'wave_target_awgn', [], ...  #wave after awgn channel and target noise (not yet fully implemented)
'param', [], ...             #set of parameters of transmitter (modulation,fec coding, etc.)
'ber', []                    # bit error rate for simulation results (more simulation paramaters will be added when necessary)



```
