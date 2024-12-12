    clear all;
%tworzenie obiektu nominalnego
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


% parametry symulacji
tmax = 1500;
y_zad = 1;

% wartosci wyjsciowe 
wyu = 0;
wyy = 0;

% parametry obiektu
a1 = G_z.Denominator{1}(2); a0 = G_z.Denominator{1}(3);
b1 = G_z.Numerator{1}(2); b0 = G_z.Numerator{1}(3);
% horyzonty
D = 69; N = 16; Nu= 1;
% wspolczynniki s
sv = step(G_z);
sv(1) = []; % uwzględniając opóźniSenie


% lambda
lambda = 7;

% y = y_pocz;
% u = y_pocz;
for i=1:D-1
    deltaupk(i)=0;
end

% generacja macierzy

% macierz M
M = zeros(N, Nu);
for i = 1:N
    for j = 1:Nu
        if i-j+1 > 0
            M(i, j) = sv(i-j+1);
        end
    end
end

% macierz Mp
Mp = zeros(N, D-1);
for i = 1:N
    for j = 1:D-1
        if j + i <= D
            Mp(i, j) = sv(i+j) - sv(j);
        else
            Mp(i, j) = sv(D) - sv(j);
        end
    end
end

% obliczenie parametrów regulatora
I = eye(Nu);
K = inv((M'*M + lambda*I))*M';
Ku = K(1,:)*Mp;
Ke = sum(K(1,:));


%tworzenie obiektu testowego
k = 0.981;
t = 1.4;
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
a1 = G_z.Denominator{1}(2); a0 = G_z.Denominator{1}(3);
b1 = G_z.Numerator{1}(2); b0 = G_z.Numerator{1}(3);

Tovals = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0];
Kovals = [2.025, 1.99, 1.91, 1.52, 0.981,0.658, 0.488, 0.405,0.3752, 0.382, 0.431];


% warunki początkowe
y_pocz = 0;
u_pocz = 0;
y(1:2*To+2) = y_pocz;
u(1:2*To+2) = u_pocz;
z(1:40) = 0.0;
z(41: tmax) = 0.0;


% główna pętla programu
for k=2*To+3:tmax

    y(k) = b1*u(k-1 - 2*To)+b0*u(k-2 - 2*To)-a1*y(k-1)-a0*y(k-2) + z(k);

    ek = y_zad - y(k);

    deltauk = Ke*ek-Ku*deltaupk';
    for n=D-1:-1:2
        deltaupk(n)=deltaupk(n-1);
    end
    deltaupk(1)=deltauk;
    u(k) = u(k-1)+deltaupk(1);

    wyu(k) = u(k);
    wyy(k) = y(k);
end

% wizualizacja działania programu
figure(1);
stairs(0:tmax, [u_pocz wyu]);hold on; grid on;
xlabel('K'); ylabel('u');
figure(2);
stairs(0:tmax, [0 y_zad*ones(1, tmax)]);
hold on; grid on;
plot(1:tmax, wyy);
xlabel('K'); ylabel('y, y_zad');

figure(3);
plot(Tovals, Kovals, '-o')
title('WYKRES OBSZARU STABILNOŚCI');
xlabel('T/T_nom'); % Etykieta osi X
ylabel('K/K_nom'); % Etykieta osi Y
grid on;
