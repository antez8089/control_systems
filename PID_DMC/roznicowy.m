[num, denum] = tfdata(G_z, 'v')
G_z

roznicowe = @(k, y, u) (-denum(2)*y(k-1) -denum(3)*y(k-2) + num(2)*u(k-11) + num(3)*u(k-12));