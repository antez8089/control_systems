% parametry transmitancji:
Ko = 7.4;
To = 5;
T1 = 2.17;
T2 = 4.4;
Tp = 0.5;

s = tf('s');
G_s = Ko * (exp(-s*To)) / ( (T1*s + 1) * (T2*s + 1));

G_z = c2d(G_s, Tp, 'zoh');

figure;
step(G_s);
hold on;
step(G_z);
legend('Transmitancja ciągła', 'Transmitancja dyskretna');
title('Odpowiedź skokowa');
grid on;
hold off;