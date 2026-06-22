# DVB-S2 radar in matlab

## File structure
```
DVB-S2-radar/
├──DVB_S2_generator.mlx         #main file        
├──parameters.m                 #simulation parameters
├──dvbs2xLDPCParityMatrices.mat #file needed for generating signal
├──awgn_channel.m               #currently not used
└──raw_data_generator.m         #currently not used
└──Examples\R2025b\satcomDVB-S2-radar\
                                    ├──HelperDVBS2RxInputGenerate.m     #main signal generator with sco and cfo
                                    ├──HelperDVBS2PhaseNoise.m          #phase noise function used to generate sco
                                    ├──...                              #other function
```

## Links 
The program uses helper functions from mathworks:
[DVB-S2 Link Simulation with RF Impairments and Corrections](https://www.mathworks.com/help/satcom/ug/end-to-end-dvbs2-simulation-with-rf-impairments-and-corrections.html)

