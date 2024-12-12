figure;
plot(out.u);

figure;
plot(out.y);
grid on;
hold on;
plot(out.zadane);
hold off;

figure;
plot(out.cx1);
grid on;
hold on;
plot(out.cx2);
plot(out.cx3);
hold off;
legend("x1", "x2", "x3");