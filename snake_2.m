function [y1, y2] = snake_2(x, y1, y2, edge_map, alpha, mu, delta_t, iter)
    y1 = reshape(y1,[],1);
    y2 = reshape(y2,[],1);
    x = reshape(x,[],1);
    n = size(x,1);
    m = size(edge_map,1);

    [~,fy] = gradient(edge_map);
    fy = fy./max(max(abs(fy)));
    fy1_of_curve = interp2(fy,x,y1,'*linear');
    fy2_of_curve = interp2(fy,x,y2,'*linear');
    lam = alpha + mu;
    A = lam * (-2 * diag(ones(1,n)) + diag(ones(1,n-1),1) + diag(ones(1,n-1),-1));
    B = mu * (-2 * diag(ones(1,n)) + diag(ones(1,n-1),1) + diag(ones(1,n-1),-1));
    A(1,1) = A(1,1) + lam;
    A(n,n) = A(n,n) + lam;
    B(1,1) = B(1,1) + mu;
    B(n,n) = B(n,n) + mu;
    A = eye(n) - delta_t * A;
    B = delta_t * B;
    C = [A,B;B,A];
    d = [fy1_of_curve; fy2_of_curve];
    y = [y1;y2];
    for i = 1:iter
        y = C \ (delta_t * d + y);
        y1 = y(1:n);
        y2 = y(n+1:end);
        fy1_of_curve = interp2(fy,x,y1,'*linear');
        fy2_of_curve = interp2(fy,x,y2,'*linear');
        d = [fy1_of_curve; fy2_of_curve];
    end
    y1(y1<1) = 1;
    y1(y1>m) = m;
    y2(y2<1) = 1;
    y2(y2>m) = m;
end