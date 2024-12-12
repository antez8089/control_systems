B = B .* 1.8;

Aexp = [A(1,1) A(1,2) A(1,3) 0;
        A(2,1) A(2,2) A(2, 3) 0;
        A(3,1) A(3,2) A(3,3) 0;
        -C(1) -C(2) -C(3) 0];
Bexp = [B(1); B(2); B(3); 0];
sc = -1;
Kexp = acker(Aexp, Bexp, [sc, sc, sc, sc]);