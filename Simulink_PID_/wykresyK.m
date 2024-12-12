figure;
plot(out.K_u);

figure;
plot(out.K_x1);
grid on;
hold on;
plot(out.K_x2);
plot(out.K_x3);
hold off;
legend("x1", "x2", "x3");
