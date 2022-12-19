function done = analyze(dat, ssRange)
    % default arg
    if ~exist('ssRange', 'var')
        ssRange = [-1, 2];
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

    % calculate SS
    
    deltaVg = gradient(vg);
    deltaLog10Id = gradient(log10(id));
    % deltaLog10Id is complex, so use abs
    deltaLog10Id = abs(deltaLog10Id);
    ss = deltaVg ./ deltaLog10Id * 1e3;
    figure;
    plot(vg, ss);
    xlabel("V_g [V]")
    xlim(ssRange);
    ylabel("SS [mV/decade]")

    % idで範囲絞り込み
    vg((id >= 1e-4) & (id <= 1e-3));
    sprintf("vg = %f\n", vg);
    minSS = min(ss((vg >= ssRange(1)) & (vg <= ssRange(2))));

    vg_minSS = vg(ss == minSS);

    fprintf("(Vg, SS) at SS's minimum: (%f, %f)\n", vg_minSS, minSS);

    done = true;
end