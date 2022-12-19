function rawplot(raw)
    figure;
    plot(raw(:, 2), raw(:, 3) * 1e4);
    xlabel("V_g")
    ylabel("I_d/W [\muA/\mum]");
end