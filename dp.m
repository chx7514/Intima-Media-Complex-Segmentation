function [x, y] = dp(I, edge_map, lam, type, bias, range0)
% dynamic programming for edge detection
% given image I, edge map and lambda
    [M, N] = size(I);
    x = 1 : N;
    y = zeros(1, N);
    range = 10;
    B = zeros(M, N);
    E = -edge_map;
    if type == 0
        range_min = ones(1, N);
        range_max = ones(1, N) * M;
    else
        range0 = range0 + bias;
        if type == 1
            range_min = range0;
            range_max = ones(1, N) * M;
        else
            range_min = ones(1, N);
            range_max = range0;
        end
    end
    
    for i = 2:N
        for j = range_min(i):range_max(i)
            Emin = 10000000;
            flag = 0;
            for k = -range:range
                if (j + k < range_min(i - 1)) || (j + k > range_max(i - 1))
                    continue;
                end
                E_tmp = E(j + k, i - 1) + lam * abs(k);
                if E_tmp <= Emin
                    Emin = E_tmp;
                    B(j, i) = j + k;
                end
            end
            E(j, i) = E(j, i) + Emin;
        end
    end
    [~, idx] = min(E(range_min(N):range_max(N),end));
    y(N) = idx + range_min(N) - 1;
    for i = N-1:-1:1
        y(i) = B(y(i+1), i+1);
    end
end