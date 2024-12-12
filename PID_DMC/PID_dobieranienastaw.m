% Skrypt do testowania różnych wartości Kk dla regulatora PID z transmitancją obiektu

% Ustawienia początkowe

Kk =0.2821585; % wzmocnienie krytyczne



const = pidstd(Kk)
step(feedback(const*G_s, 1))

% z wykresu odczytuje Tk = 20