function done = analyze(dat, ssRange, filename)
    % default arg
    if ~exist('ssRange', 'var')
        ssRange = [-1, 2];
    end
    if ~exist('filename', 'var')
        filename = "plot";
    end

    % plot the raw data
    figure;
    hold on;
    vg = dat(:, 1);
    id = dat(:, 2) * 1e4;
    % left side: Vg-Id
    yyaxis left;
    plot(vg, id);
    xlabel("V_g [V]");
    ylabel("I_d/W [\muA/\mum]");
    % right side: Vg-gm
    yyaxis right;
    gm = gradient(id) ./ gradient(vg);
    plot(vg, gm);
    ylabel("g_m [mS/\muS]");
    vg0 = vg(gm == max(gm)); % 相互コンダクタンスgm
    fprintf("vg0 = %f\n", vg0);
    xline(vg0)

    % calculate Vth
    id0 = id(vg == vg0); % Id at gm's peak
    fprintf("id0 = %f\n", id0);
    grad0 = max(gm); % gm(=slope of Id) at gm's peak
    vth = vg0 - id0 / grad0;
    fprintf("Vth = %f\n", vth);
    
    % draw the tangent line
    yyaxis left
    tangent = [vth, 0; vg0, id0];
    line(tangent(:, 1), tangent(:, 2), "Color", "#808080");
    hold off;
    save_filepath = sprintf("plot/day1/%s_Vg_Id.png", filename);
    saveas(gcf, save_filepath);

    % calculate SS
    
    deltaVg = gradient(vg);
    deltaLog10Id = gradient(log10(id));
    % deltaLog10Id is complex, so use abs
    deltaLog10Id = abs(deltaLog10Id);
    ss = deltaVg ./ deltaLog10Id * 1e3;
    figure;
    hold on;
    plot(vg, ss);
    xlabel("V_g [V]")
    xlim(ssRange);
    ylabel("SS [mV/decade]")
    % plot theoretical value
    u = symunit;
    [e, ~] = separateUnits(unitConvert(u.e, 'SI'));
    e = double(e);
    [k, ~] = separateUnits(unitConvert(u.k_B, 'SI'));
    k = double(k);
    yline(log(10) * k * 293 * 1e3 / e);
    legend("observed", "theoretical limit(t=20℃)");
    hold off;
    save_filepath = sprintf("plot/day1/%s_Vg_SS.png", filename);
    saveas(gcf, save_filepath);

    minSS = min(ss((vg >= ssRange(1)) & (vg <= ssRange(2))));

    vg_minSS = vg(ss == minSS);

    fprintf("(Vg, SS) at SS's minimum: (%f, %f)\n", vg_minSS, minSS);

    done = true;
end