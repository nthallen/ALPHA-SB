%%
Iport = scopexeng_2.PMC_Left_I_Measured;
RPMport = scopexeng_2.PMC_Left_RPM;
T2 = scopexeng_2.T;
Ib3mb = scopexeng_1.B3MB_100V1_Load1_I;
Vb3mb = scopexeng_1.B3MB_100V1_Load1_V;
T1 = scopexeng_1.T;
%%
figure;
ax = [nsubplot(2,1,1) nsubplot(2,1,2)];
plot(ax(1),T2,Iport,T1,Ib3mb);
plot(ax(2),T1,Vb3mb);
%%
Kt = 0.550; % Torque sensitivity
Pport = Iport .* Kt .* RPMport * 60;
Pb3mb = Ib3mb .* Vb3mb;
%%
figure;
plot(T2,Pport,T1,Pb3mb);
legend('AMC','B3MB');
%%
% Try just using RPM to get voltage...
Ke = 33.24; % V/KRPM
Vrpm_port = 19.7 + RPMport * 1e-3 * Ke;
Wport = Vrpm_port .* Iport;
%%
figure;
plot(T2,Wport,T1,Pb3mb);
legend('AMC','B3MB');
%%
V1 = T1 > 59000;
V2 = T2 > 59000;
Pb3mb_2 = interp1(T1(V1),Pb3mb(V1),T2(V2));
Vdiv = Pb3mb_2 ./ Iport(V2);
figure;
ax = [ nsubplot(2,1,1) nsubplot(2,1,2)];
plot(ax(1),T2(V2),Vdiv);
plot(ax(2),T2(V2),RPMport(V2));