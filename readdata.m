function dat = readdata(filename, isLatter)
    raw = readmatrix(filename);
    if isLatter
        dat = raw(203:403, 2:3);
    else
        dat = dat(2:202, 2:3);
    end
end