clear all;
%tworzenie obiektu testowego
k =1;
t = 1;
Ko = k * 7.4;
To = t * 5;
T1 = 2.17;
T2 = 4.4;
Tp = 0.5;                   

opoznienie = 2*To;

s = tf('s');
G_s = Ko * (exp(-s*To)) / ( (T1*s + 1) * (T2*s + 1));

G_z = c2d(G_s, Tp, 'zoh');
[num, denum] = tfdata(G_z, 'v');

Tovals = [1, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0];
Kovals = [1.581, 1.507, 1.451, 1.395, 1.345, 1.299, 1.257, 1.215, 1.184, 1.148, 1.112];


%nastawy
Kk = 0.2821585;
Tk = 20;

Kp = 0.6*Kk;
Ti = 0.5*Tk;
Td = 0.12*Tk;
Tp = 0.5;


PIDC = pidstd(Kp, Ti, Td);
step(feedback(PIDC*G_s, 1));


r0 = Kp * (1 + Tp / (2 * Ti) + Td / Tp);
r1 = Kp * (-1 + Tp / (2 * Ti) - 2 * Td / Tp);
r2 = Kp * (Td / Tp);


clear u y yzad e

%inicjalizacja
a1= denum(2);
a0= denum(3);
b1= num(2);
b0= num(3);
kk=140; %koniec symulacji
%warunki początkowe
u(1:opoznienie +3)=0; y(1:opoznienie +3)=0;
yzad(1:kk)=1;
e(1:opoznienie +3)=0;  

for k=opoznienie +3 :kk %główna pętla symulacyjna
%symulacja obiektu
 y(k)=b1*u(k-1 - opoznienie)+b0*u(k-2 - opoznienie)-a1*y(k-1)-a0*y(k-2);
%uchyb regulacji
 e(k)=yzad(k)-y(k);
%sygnał sterujący regulatora PID
 u(k)=r2*e(k-2)+r1*e(k-1)+r0*e(k)+u(k-1);
end
%wyniki symulacji
figure; stairs(u);
title('u'); xlabel('k');
figure; stairs(y), hold on;
stairs(yzad,':');
title('yzad, y'); xlabel('k'),  hold off;

figure;
plot(Tovals, Kovals, '-o')
title('WTKRES OBSZARU STABILOSNCI');
xlabel('To/Tonom'); % Etykieta osi X
ylabel('K/Konom'); % Etykieta osi Y
grid on;