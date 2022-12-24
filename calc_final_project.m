% use this to iterate the design
clc
clear

%% variables

Cl = 5*10^-12
Cm = Cl/4
GBWf = 17000
GBW = 17000*2*pi
gain = 223.87

gain_stage_one = 46.546 %get from Vov and gm/gds
L1 = 1000*10^-9 %choose based on gain
Vov1 = 0
L2 = L1
Vov2 = Vov1

%gain_stage_two = gain/gain_stage_one
gain_stage_two = 7.99426 %get from Vov and gm/gds
L6 = 60*10^-9
Vov6 = 0
 
gain_eff1 = 22.2450 %get from VOv and gm/IDS
gain_eff2 = gain_eff1
gain_eff6 = 11.3299 %get from Vov and gm/IDS

L8 = 500*10^-9 %choose
L5 = L8
Vov8 = 0
Vov7 = 0
Vov5 = 0

L3 = 500*10^-9 %choose
L4 = L3
Vov3 = 0
Vov4 = Vov3

gain_eff3 = 27.5157 %get from plot Vov and gm/IDS
gain_eff4 = gain_eff3

gain_M3 = 27.6 %get from Vov and gm/gds
gain_M4 = gain_M3

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

go1 = gm1/gain_stage_one
go2 = go1
go6 = gm6/gain_stage_two

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

go4 = gm4/gain_M4
go3 = go4


%% calculate vgs
%get from Vgs and gm/gds

vgs1 = -.022 
vgs4 = 0.09



