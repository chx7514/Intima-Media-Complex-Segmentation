function [y] = snake_1d(x, y, edge_map, alpha, beta, delta_t, iter)
a_0 = -2*alpha - 6*beta;
a_1 = alpha + 4*beta;
a_2 = -beta;

% n代表列数,m代表行数
n = size(x,2);
m = size(edge_map,1);
A = diag(a_0*ones(n,1))+diag(a_1*ones(n-1,1),1)+diag(a_1*ones(n-1,1),-1);
A = A + diag(a_2*ones(n-2,1),2) + diag(a_2*ones(n-2,1),-2);
% boundary condition
A(1,1) = A(1,1) + a_1 + a_2;
A(2,1) = A(2,1) + a_2;
A(n,n) = A(n,n) + a_1 + a_2;
A(n-1,n) = A(n-1,n) + a_2;

y = reshape(y,[],1);
x = reshape(y,[],1);
identity = eye(n);

[fx,fy] = gradient(edge_map);
fy = sqrt(fx.^2+fy.^2);
% fy = fy./max(max(abs(fy)));
fy_of_curve = interp2(fy,y,x,'*linear');
for i = 1:iter
    y = (identity + delta_t * A)\(y + delta_t * fy_of_curve);
    fy_of_curve = interp2(fy,y,x,'*linear');
end
y_ind = y;
% y_ind = round(y);
y_ind(y_ind>m) = m;
y_ind(y_ind<1) = 1;
y = y_ind;