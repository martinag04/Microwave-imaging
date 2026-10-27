close all
clear all
clc

N = 22;
load('meas_MT_13.mat')
Z0 = 50;

write_s22p(Sm, freq, Z0, '22_small_stroke2_nocal.s22p');
sparam = sparameters('22_small_stroke2_nocal.s22p');

figure
plot(freq./1e9,20*log10(abs(squeeze(Sm(1,1,:)))))
hold on
rfplot(sparam, 1, 1);  % Plot S11
