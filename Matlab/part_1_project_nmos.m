%% Session1 HW: gm, gds, gm/IDS and gm/gds vs VGS for different L
% check dependencies in conclusion

%% Loading MOS tables
addpath(genpath('circuitDesign'));
addpath(genpath('functions'));
addpath(genpath('models'));


load ('UMC65_RVT.mat');

%% Initialize everything
designkitName   = 'umc65';
circuitTitle    = 'Analog Design';

%Declaration of the circuit components
elementList.nmos = {'Mn2'};

spec.VDD        = 1.1;
choice.maxFingerWidth = 10e-6;
choice.minFingerWidth = 200e-9;
simulator       ='spectre';
simulFile       = 0;
simulSkelFile   = 0;
analog = cirInit('analog', circuitTitle, 'top', elementList, spec , choice,...
    designkitName, NRVT, PRVT, simulator, simulFile, simulSkelFile);

analog          = cirCheckInChoice(analog, choice);

%% Circuit
disp('     spec.VDD/2       ');
disp('        |             ');
disp('        |             ');
disp('  Vg---Mpx            ');
disp('        |             ');
disp('        Vs            ');

fprintf('\n--- First Exercise: Designing transistor from scratch ---\n');


%% Intrinsic gain versus VGS for different L
VGS = (0:0.005:spec.VDD).'; % [V], gate source voltage
L   = [60 80 100 200 500 1000 2000]*1e-9; % [m], gate length
gm  = NaN(length(L),length(VGS));
gds = NaN(length(L),length(VGS));
gmIDS = NaN(length(L),length(VGS));
gdsIDS = NaN(length(L),length(VGS));
Av    = NaN(length(L),length(VGS));
Av_db = NaN(length(L),length(VGS));
VOV   = NaN(length(L),length(VGS));
w     = NaN(length(L),length(VGS));
ft    = nan(length(L), length(VGS));
IDS   =  NaN(length(L),length(VGS));

Mn2.vds = 0.550;
Mn2.vsb = 0;

for kk = 1:length(L)
    Mn2.lg = L(kk);
    Mn2.w = 5*Mn2.lg; %% W/L = 10
    for i=1:length(VGS)
        Mn2.vgs = VGS(i);
        Mn2 = mosNfingers(Mn2);
        Mn2 = mosOpValues(Mn2);
        
        VOV(kk,i) = Mn2.vov;
        gm(kk,i) = Mn2.gm;
        gds(kk,i) = Mn2.gds;
        gmIDS(kk,i) = Mn2.gm/Mn2.ids;
        gdsIDS(kk,i) = Mn2.gds/Mn2.ids;
        Av(kk,i) = Mn2.gm / Mn2.gds;
        Av_db(kk,i) = 20*log10(Mn2.gm / Mn2.gds);
        ft(kk, i) = Mn2.ft/1e9;
        IDS(kk,i) = Mn2.ids;
                     
    end
end

%%

Mn4.vgs = 0.3537;
Mn4.vds = 0.55;
Mn4.vsb = 0;

aspect = 42;
Mn4.lg = 80e-9;
Mn4.w = Mn4.lg*aspect;

Mn4 = mosNfingers(Mn4);
Mn4 = mosOpValues(Mn4);

disp("currently: ")

disp("ids = ")
disp(Mn4.ids)
disp("gds = ")
disp(Mn4.gds)
disp("gm = ")
disp(Mn4.gm)
disp("Vov = ")
disp(Mn4.vov)


%% Plot

figure;
plot(VGS, VOV,'linewidth',2);
xlabel('VGS (V)');
ylabel('VOV (V)');
grid on;
title('VOV vs. VGS (W/L=10, VDS = 0.55 V)@')
legend('60n','80n','100n','200n','500n','1000n');

figure();
subplot(221); plot(VGS,gm,'linewidth',2);
xlabel('VGS (V)');
ylabel('gm (mag)');
grid on;
title('gm vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(222); plot(VGS,gds,'linewidth',2);
xlabel('VGS (V)');
ylabel('gds (mag)');
grid on;
title('gds vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(223); plot(VGS,Av,'linewidth',2);
xlabel('VGS (V)');
ylabel('gm/gds (mag)');
grid on;
title('Intrinsic gain (gm/gds) vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(224); plot(VGS,gmIDS,'linewidth',2);
xlabel('VGS (V)');
ylabel('gm/IDS (mag)');
grid on;
title('Gain efficiency (gm/Ids) vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');

figure();
subplot(221); plot(VOV.',gm.','linewidth',2);
xlabel('VOV (V)');
ylabel('gm (mag)');
grid on;
title('gm vs. VOV for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(222); plot(VOV.',gds.','linewidth',2);
xlabel('VOV (V)');
ylabel('gds (mag)');
grid on;
title('gds vs. VOV for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(223); plot(VOV.',Av.','linewidth',2);
xlabel('VOV (V)');
ylabel('gm/gds (mag)');
grid on;
title('Intrinsic gain (gm/gds) vs. VOV for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
subplot(224); plot(VOV.',gmIDS.','linewidth',2);
xlabel('VOV (V)');
ylabel('gm/IDS (mag)');
grid on;
title('Gain efficiency (gm/Ids) vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');

figure;
semilogy(VOV.',ft.','linewidth',2);
title('ft vs. VOV for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');
xlabel('VOV (V)')
ylabel('ft (GHz)')

figure;
plot(VGS.',IDS.','linewidth',2);
title('IDS');
legend('60n','80n','100n','200n','500n','1000n');
xlabel('VOV (V)')
ylabel('IDS')

figure(); plot(VGS,gmIDS,'linewidth',2);
xlabel('VGS (V)');
ylabel('gds/IDS (mag)');
grid on;
title(' (gds/Ids) vs. VGS for different channel lenght (W/L=10, VDS = 0.55V)');
legend('60n','80n','100n','200n','500n','1000n');

