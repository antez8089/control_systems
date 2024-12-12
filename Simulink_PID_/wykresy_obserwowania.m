figure;
plot(out.K_x1);
grid on;
hold on;
plot(out.K_x2);
plot(out.K_x3);
hold off;
legend("x1", "x2", "x3");

figure;
plot(out.xo1);
grid on;
hold on;
plot(out.xo2);
plot(out.xo3);
hold off;
legend("xo1", "xo2", "xo3");
