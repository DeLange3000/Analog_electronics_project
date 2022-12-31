% use this to iterate the design
clc
clear

%% variables ADJUST ONLY THIS PART

Vdd = 1.1

Cl = 5*10^-12
Cm = Cl/4
GBWf = 17000000
GBW = 17000000*2*pi
gain = 223.87

%choose M1 and M2 based on DC gain stage 1
gain_stage_one = 19.2 %get from Vov and gm/gds
L1 = 1000*10^-9 %choose based on gain
Vov1 = -0.2

%choose M6 based on total DC gain divided by gain stage 1
%gain_stage_two = gain/gain_stage_one
gain_stage_two = 13.6 %get from Vov and gm/gds
L6 = 100*10^-9
Vov6 = 0.2

% get gain efficiency of M1 and M6
gain_eff1 = 8.45 %get from VOv and gm/IDS
gain_eff6 = 6.95 %get from Vov and gm/IDS

%choose length M8 based on current behaviour
Vov8 = 0.2
Vov7 = 0
Vov5 = 0.2
L5 = 60*10^-9

%choose length M3 and M4 based on 
L3 = 60*10^-9 %choose
Vov3 = -0.1

%get gain of M3 and M4
gain_M3 = 7.6 %get from Vov and gm/gds

%get gain efficiency of M3 and M4
gain_eff3 = 23.1 %get from plot Vov and gm/IDS

%get Vgs of M1, M2, M3 and M4
vgs1 = -0.42 %get from Vgs and gm/gds
vgs4 = 0.21
vgs5 = -0.17
vgs6 = 0.56


%% apply symmetries

L2 = L1
Vov2 = Vov1

gain_M4 = gain_M3

gain_eff2 = gain_eff1

L4 = L3
L8 = L5

Vov4 = Vov3

gain_eff4 = gain_eff3

vgs2 = vgs1
vgs3 = vgs4
%% gm1 and gm6

gm6 = 3*GBW*Cl
gm1 = GBW * Cm
gm2 = gm1
go1_go6 = (gm1*gm6)/gain

%% vds

vds1 = -0.336
vds2 = vds1
vds7 = vds1

vds3 = 0.336
vds4 = vds3

vds8 = -0.550
vds5 = vds8

vds6 = 0.550

%% calc go1 and go2

go1 = (gm1/gain_stage_one)/2
go2 = go1
go6 = gm6/(gain_stage_two)/2
go5 = go6

%% get Id1 and Id6

Id1 = gm1/gain_eff1
Id2 = Id1

Id6 = gm6/gain_eff6

%% get Id3, Id4 and Id5

Id4 = Id1
Id3 = Id4
Id7 = 2*Id1
Id5 = Id6

%% choose Ibias and Id8

Id8 = Id6
Ibias = Id8

%% choose L7 and L5

L7 = L8/(Id7/Id8)
W7 = 10*L8



%% choose gm3 and gm4

gm3 = gain_eff3*Id3
gm4 = gm3

%% calculate go3 and go4

 %go4 = gm4/gain_M4
 %go3 = go4

%% calculate Vcm and output swing and Pdiss

Vcm_max = Vov2 - vgs2 + Vov4 - vgs4 + Vov4 +Vdd
Vcm_min = Vov7 + Vov2 + Vov2 - vgs2

Vout_max = Vdd - Vov5
Vout_min = 2*vgs6 - Vov6

Pdiss = Vdd*Ibias

