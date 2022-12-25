% use this to iterate the design
clc
clear

%% variables ADJUST ONLY THIS PART

Vdd = 1.1

Cl = 5*10^-12
Cm = Cl/4
GBWf = 17000
GBW = 17000*2*pi
gain = 223.87

%choose M1 and M2 based on DC gain stage 1
gain_stage_one = 27.5 %get from Vov and gm/gds
L1 = 500*10^-9 %choose based on gain
Vov1 = -0.1

%choose M6 based on total DC gain divided by gain stage 1
%gain_stage_two = gain/gain_stage_one
gain_stage_two = 10.25 %get from Vov and gm/gds
L6 = 70*10^-9
Vov6 = 0.1

% get gain efficiency of M1 and M6
gain_eff1 = 13.24 %get from VOv and gm/IDS
gain_eff6 = 9 %get from Vov and gm/IDS

%choose length M8 based on current behaviour
L8 = 500*10^-9 %choose
Vov8 = 0
Vov7 = 0
Vov5 = 0

%choose length M3 and M4 based on current behaviour
L3 = 500*10^-9 %choose
Vov3 = 0

%get gain efficiency of M3 and M4
gain_eff3 = 27.5157 %get from plot Vov and gm/IDS

%get gain of M3 and M4
gain_M3 = 27.6 %get from Vov and gm/gds
gain_M4 = gain_M3

%get Vgs of M1, M2, M3 and M4
vgs1 = -0.034 %get from Vgs and gm/gds
vgs4 = 0.05
vgs6 = 0.47


%% apply symmetries

L2 = L1
Vov2 = Vov1

gain_eff2 = gain_eff1

L5 = L8

L4 = L3

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

%go1 = gm1/gain_stage_one
%go2 = go1
%go6 = gm6/gain_stage_two

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

%% choose L7

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
Vout_min = 2*vgs4 - Vov4

Pdiss = Vdd*Ibias

