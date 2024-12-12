licznik = conv([1, 0.5], [1, 2.5]);
mianownik = conv(conv([1, 5], [1, 3]), [1, 4]);
[A, B, C, D] = tf2ss(licznik, mianownik);

syms s
Gs = C.*(s*eye(3) - A)^-1 .*B +D;



[licz2, mian2] = ss2tf(A,B,C,D);
sk = -2;
K = acker(A,B, [sk sk sk]);

so = -2;
L = acker(A', C', [so so so]);
