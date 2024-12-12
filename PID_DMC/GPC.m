clear all;
%tworzenie obiektu nominalnego
k =1;
t = 1;
Ko = k * 7.4;
Too = t * 5;
T1 = 2.17;
T2 = 4.4;
Tp = 0.5;

s = tf('s');
G_s = Ko * (exp(-s*Too)) / ( (T1*s + 1) * (T2*s + 1));

G_z = c2d(G_s, Tp, 'zoh');
[num, denum] = tfdata(G_z, 'v');

% parametry symulacji
tmax = 150;
y_zad = 1;

% wartosci wyjsciowe 
wyu = 0;
wyy = 0;

% parametry obiektu
a1 = G_z.Denominator{1}(2); a0 = G_z.Denominator{1}(3);
b1 = G_z.Numerator{1}(2); b0 = G_z.Numerator{1}(3);
% horyzonty
N = 16; Nu = 1;

% wspolczynniki s
sv = step(G_z);
sv(1) = []; % uwzględniając opóźnienie

%lambda
lambda = 7;


% macierz M
M = zeros(N, Nu);
for i = 1:N
    for j = 1:Nu
        if i-j+1 > 0
            M(i, j) = sv(i-j+1);
        end
    end
end

% obliczenie parametrów regulatora
I = eye(Nu);
K = inv((M'*M + lambda*I))*M';


%tworzenie obiektu testowego
k =1.297;
t = 1.;
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

Tovals = [1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0];
Kovals = [1.3035, 1.3233, 1.297, 1.247, 1.188, 1.133, 1.092, 1.068, 1.0625, 1.066, 1.077];

% wartosci wyjsciowe 
wyu = 0;
wyy = 0;

% parametry obiektu
a1t = G_z.Denominator{1}(2); a0t = G_z.Denominator{1}(3);
b1t = G_z.Numerator{1}(2); b0t = G_z.Numerator{1}(3);

% warunki początkowe
y_zad = 1;
tmax = 1500;
y_pocz = 0;
u_pocz = 0;
y(1:2*To+2) = y_pocz;
u(1:2*To+2) = u_pocz;
z(1:40) = 0.0;
z(41: tmax) = 0.0;


% główna pętla programu
for k=2*To+3:tmax
    % obiekt
    y(k) = b1t*u(k-1 - 2*To)+b0t*u(k-2 - 2*To)-a1t*y(k-1)-a0t*y(k-2)+ z(k);
    
    d(k) = y(k) - (b1*u(k-1 - 2*To)+b0*u(k-2 - 2*To)-a1*y(k-1)-a0*y(k-2));
    

    y0(1) = b1*u(k - 2*Too)+b0*u(k-1 - 2*Too)-a1*y(k)-a0*y(k-1)+d(k);
    y0(2) = b1*u(k - 2*Too + 1)+b0*u(k - 2*Too)-a1*y0(1)-a0*y(k) + d(k);
    for n = 3:N
        if n == 10
            y0(n) = b1*u(k-1)+b0*u(k-2)-a1*y0(n-1)-a0*y0(n-2) + d(k);
        elseif n>= 11
            y0(n) = b1*u(k-1)+b0*u(k-1)-a1*y0(n-1)-a0*y0(n-2) + d(k);
        else
            y0(n) = b1*u(k-1 - 2*Too + n)+b0*u(k-2 - 2*Too + n)-a1*y0(n-1)-a0*y0(n-2) + d(k);
        end
    end
    
    deltauk=K(1,:)*(y_zad*ones(1,N)-y0)';
    deltaupk(1)=deltauk;
    u(k) = u(k-1)+deltaupk(1);

    wyu(k) = u(k);
    wyy(k) = y(k);
end

% wizualizacja działania programu
figure(1);
stairs(0:tmax, [u_pocz wyu]);hold on; grid on;
xlabel('czas'); ylabel('u');
figure(2);
stairs(0:tmax, [0 y_zad*ones(1, tmax)]);
hold on; grid on;
plot(1:tmax, wyy);
xlabel('czas'); ylabel('y, y_zad');

figure(3);
plot(Tovals, Kovals, '-o')
title('WTKRES OBSZARU STABILOSNCI');
xlabel('To/Tonom'); % Etykieta osi X
ylabel('K/Konom'); % Etykieta osi Y
grid on;