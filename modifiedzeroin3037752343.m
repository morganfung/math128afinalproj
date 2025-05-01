function [root, info] = modifiedzeroin3037752343(func, Int, params)
    x_0 = Int.a;
    x_1 = Int.b;
    x_2 = (1 / 2) * (x_0 + x_1);

    f_0 = func(x_0);
    f_1 = func(x_1);
    f_2 = func(x_2);

    prev_1 = NaN;
    prev_2 = NaN;
    prev_3 = NaN;
    prev_4 = NaN;

    root_found = false;
    used_bisection = false;

    while root_found ~= true
        while root_found ~= true

            if abs(x_1 - x_0) <= params.root_tol
                root_found = true;
                info.flag = 0;
                root = (1 / 2) * (x_0 + x_1);
                break
            end

            if used_bisection
                x_2 = (1 / 2) * (x_0 + x_1);
                f_2 = func(x_2);
                used_bisection = false;
            end

            x_3 = IQI(x_0, x_1, x_2, f_0, f_1, f_2);

            if x_3 < Int.a || x_3 > Int.b
                break;
            end

            f_3 = func(x_3);

            if abs(f_3) <= params.func_tol
                root_found = true;
                info.flag = 0;
                root = x_3;
                break;
            end

            if ~isnan(prev_1)
                if abs(f_3) >= 1/2 * abs(prev_1)
                    break;
                end
            end

            prev_1 = prev_2;
            prev_2 = prev_3;
            prev_3 = prev_4;
            prev_4 = f_3;

            if f_0 * f_2 < 0
                temp = [x_0, x_2, x_3];
                temp_x0 = x_0;
                temp_x2 = x_2;
                temp_x3 = x_3;
                temp_f0 = f_0;
                temp_f2 = f_2;
                temp_f3 = f_3;

                x_0 = min(temp);

                if x_0 == temp_x0
                    f_0 = temp_f0;
                elseif x_0 == temp_x2
                    f_0 = temp_f2;
                else
                    f_0 = temp_f3;
                end

                x_1 = max(temp);

                if x_1 == temp_x0
                    f_1 = temp_f0;
                elseif x_1 == temp_x2
                    f_1 = temp_f2;
                else
                    f_1 = temp_f3;
                end

                if x_0 ~= temp_x0 && x_1 ~= temp_x0
                    x_2 = temp_x0;
                    f_2 = temp_f0;
                elseif x_0 ~= temp_x2 && x_1 ~= temp_x2
                    x_2 = temp_x2;
                    f_2 = temp_f2;
                else
                    x_2 = temp_x3;
                    f_2 = temp_f3;
                end

                continue;
            end

            if f_2 * f_1 < 0
                temp = [x_1, x_2, x_3];
                temp_x1 = x_1;
                temp_x2 = x_2;
                temp_x3 = x_3;
                temp_f1 = f_1;
                temp_f2 = f_2;
                temp_f3 = f_3;

                x_0 = min(temp);

                if x_0 == temp_x1
                    f_0 = temp_f1;
                elseif x_0 == temp_x2
                    f_0 = temp_f2;
                elseif x_0 == temp_x3
                    f_0 = temp_f3;
                end

                x_1 = max(temp);

                if x_1 == temp_x1
                    f_1 = temp_f1;
                elseif x_1 == temp_x2
                    f_1 = temp_f2;
                else
                    f_1 = temp_f3;
                end

                if x_0 ~= temp_x1 && x_1 ~= temp_x1
                    x_2 = temp_x1;
                    f_2 = temp_f1;
                elseif x_0 ~= temp_x2 && x_1 ~= temp_x2
                    x_2 = temp_x2;
                    f_2 = temp_f2;
                else
                    x_2 = temp_x3;
                    f_2 = temp_f3;
                end
                
                continue;
            end
        end

        if root_found == true
            break
        end

        [x_0, x_1, f_0, f_1] = bisection(func, x_0, x_1, f_0, f_1, params.func_tol);
        used_bisection = true;
    end
end


function x_3 = IQI(x_0, x_1, x_2, f_0, f_1, f_2)
    x_3 = ((f_1 * f_2) / ((f_0 - f_1) * (f_0 - f_2)) * x_0) + ((f_0 * f_2) / ((f_1 - f_0) * (f_1 - f_2)) * x_1) + ((f_0 * f_1) / ((f_2 - f_0) * (f_2 - f_1)) * x_2);
end


function [a, b, f_a, f_b] = bisection(func, a, b, f_a, f_b, tol)
    p = (a + b) / 2;
    if p - a < tol
        b = p;
        return;
    end

    f_p = func(p);

    if f_a * f_p > 0
        a = p;
        f_a = f_p;
    else
        b = p;
        f_b = f_p;
    end
end 
