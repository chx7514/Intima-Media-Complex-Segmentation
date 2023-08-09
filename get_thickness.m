% 使用两种方法定义厚度。首先选择上下曲线横坐标相同的点，求其梯度并对两者求平均
% 然后从上曲线的点或下曲线的点或中点出发，求其到另一端的距离，即为此处的厚度
% 在此代码中仅实现从上点和下点出发的方法
function [thickness] = get_thickness(up, down, mode)
    up = reshape(up,[],1);
    down = reshape(down,[],1);
    n = size(down, 1);
    mid = (up + down) / 2;
    grad = gradient(mid);
    thickness = zeros(n, 1);
    range = 3;
    x = 1:n;
    fill([x,fliplr(x)],[up',fliplr(down')],'r'); hold on;
    for i = 1:n
        if abs(grad(i)) < 1e-3
            thickness(i) = abs(up(i)-down(i));
            line([i,i], [up(i),down(i)]);
        else
            if mode == 0
                k1 = -1 / grad(i);
                b1 = mid(i)-k1*i;
                flag = 0;
                for j = -range:range
                    if i+j < 1 || i+j+1 > n
                        continue;
                    end
                    k2 = up(i+j+1)-up(i+j);
                    b2 = up(i+j)-k2*(i+j);
                    x1 = (b2-b1)/(k1-k2);
                    if x1 < i+j || x1 > i+j+1
                        continue
                    else
                        flag = 1;
                        y1 = k2 * x1 + b2;
                        thick_tmp = sqrt((mid(i)-y1)^2+(i-x1)^2);
                        break;
                    end
                end
                if flag
                    flag = 0;
                    for j = -range:range
                        if i+j < 1 || i+j+1 > n
                            continue;
                        end
                        k2 = down(i+j+1)-down(i+j);
                        b2 = down(i+j)-k2*(i+j);
                        x2 = (b2-b1)/(k1-k2);
                        if x2 < i+j || x2 > i+j+1
                            continue
                        else
                            flag = 1;
                            y2 = k2 * x2 + b2;
                            thick_tmp = thick_tmp + sqrt((mid(i)-y2)^2+(i-x2)^2);
                            break;
                        end
                    end
                end
                if flag
                    thickness(i) = thick_tmp;
                    line([x1,x2],[y1,y2]);
                end
            else
                if mode == 1
                    k1 = -1 / grad(i);
                    b1 = down(i)-k1*i;
                    flag = 0;
                    for j = -range:range
                        if i+j < 1 || i+j+1 > n
                            continue;
                        end
                        k2 = up(i+j+1)-up(i+j);
                        b2 = up(i+j)-k2*(i+j);
                        x1 = (b2-b1)/(k1-k2);
                        if x1 < i+j || x1 > i+j+1
                            continue
                        else
                            y1 = k2 * x1 + b2;
                            thickness(i) = sqrt((down(i)-y1)^2+(i-x1)^2);
                            flag = 1;
                            break;
                        end
                    end
                    if flag
                        line([x1,i],[y1,down(i)]);
                    end
                else
                    k1 = -1 / grad(i);
                    b1 = up(i)-k1*i;
                    flag = 0;
                    for j = -range:range
                        if i+j < 1 || i+j+1 > n
                            continue;
                        end
                        k2 = down(i+j+1)-down(i+j);
                        b2 = down(i+j)-k2*(i+j);
                        x1 = (b2-b1)/(k1-k2);
                        if x1 < i+j || x1 > i+j+1
                            continue
                        else
                            y1 = k2 * x1 + b2;
                            thickness(i) = sqrt((up(i)-y1)^2+(i-x1)^2);
                            flag = 1;
                            break;
                        end
                    end
                    if flag
                        line([x1,i],[y1,up(i)]);
                    end
                end
            end
        end
    end
end
