% Copyright (C) 2025 by Raehyun Kim (rhkim79@math.berkeley.edu)
% Final Version
clc; clear;
%% EASY / full score if num_fcall <= 25
func1 = @(x) x*exp(-x) - 2*x + 1;           Int1.a = 0;     Int1.b = 3;
func2 = @(x) x*cos(x) - 2*x^2 + 3*x - 1;    Int2.a = 1;     Int2.b = 3;
func3 = @(x) x^3-7*x^2+14*x-6;              Int3.a = 0;     Int3.b = 1;
func4 = @(x) sqrt(x)-cos(x);                Int4.a = 0;     Int4.b = 1;
func5 = @(x) 2*x*cos(2*x) - (x+1)^2;        Int5.a = -4;    Int5.b = -2;
%% HARD / full score + extra if num_fcall <= 25 
func6 = @(x) x^3 - 32*x + 128;              Int6.a = -8;    Int6.b = 0;
func7 = @(x) x^4 -2*x^3-4*x^2+4*x+4;        Int7.a = 0;     Int7.b = 2;
func8 = @(x) -x^3 - cos(x);                 Int8.a = -3;    Int8.b = 3;
func9 = @(x) (x-5)^7 - 1e-1;                Int9.a = 0;   Int9.b = 10; 
func10 = @(x) (x-3)^11;                     Int10.a = 2.4;   Int10.b = 3.4; 

test_functions = {func1, func2, func3, func4, func5, func6, func7, func8, func9, func10};
test_intervals = {Int1, Int2, Int3, Int4, Int5, Int6, Int7, Int8, Int9, Int10};

params.root_tol = 1e-7; params.func_tol = 1e-7;

nsize = size(test_functions);
ntest = nsize(2);
for j = 1:ntest
    func = test_functions{j}; Int = test_intervals{j};
    disp("#####")
    profile on
    %%%%
    % PUT YOUR FUNCTION NAME BELOW e.g.
    % [root, info] = modifiedzeroin31415926535(func, Int, params)
    %%%%
    [root, info] = modifiedzeroin31415926535(func, Int, params);
    profile off
    
    % Verify root
    if ~isnan(root)
        root_tol_check = abs(root - fzero(func, root)) < params.root_tol;
    else
        root_tol_check = false;
    end
    func_tol_check = abs(func(root)) < params.func_tol;
    int_check = (root > Int.a) & (root < Int.b);
    if (root_tol_check || func_tol_check) && int_check
        flag_root = true;
        score_acc(j) = 70;
    else
        flag_root = false;
        score_acc(j) = 0;
    end
    % check # of function calls
    p = profile('info');
    foo = {p.FunctionTable.CompleteName};
    bar = strfind(foo, func2str(func));
    bar2 = strfind(foo, vectorize(func2str(func)));
    fcall_idx = find(~cellfun(@isempty, bar));
    fcall_idx2 = find(~cellfun(@isempty, bar2));
    num_fcall = 0;
    if ~isempty(fcall_idx)
        sz = size(fcall_idx);
        num_fcall = num_fcall + p.FunctionTable(fcall_idx(1)).NumCalls;
        if sz(2) == 2
            num_fcall = num_fcall + p.FunctionTable(fcall_idx(2)).NumCalls;
        end
    end
    if ~isempty(fcall_idx2) && (~isequal(fcall_idx, fcall_idx2))
        num_fcall = num_fcall + p.FunctionTable(fcall_idx2).NumCalls;
    end
    thd1 = 25;
    %%
    % compute score_eff
    if num_fcall <= thd1
        score_eff(j) = 30;        
    else
        score_eff(j) = 0;
    end

    if score_eff(j) == 30 && j >= 6
        score_extra(j) = true;
    else
        score_extra(j) = false;
    end
    if flag_root
        fprintf("Test function %d : Found with %d calls !! \n", ...
            j, num_fcall);
        score_tot(j) = score_acc(j) + score_eff(j);
        fprintf("acc : %.2f \t eff : %.2f \t extra : %.2f \t \n", ...
            score_acc(j), score_eff(j), score_extra(j));
    else
        fprintf("Test function %d : Failed with %d calls !! \n", ...
            j, num_fcall);
        score_tot(j) = 0;
        fprintf("acc : %.2f \t eff : %.2f \t extra : %.2f \t \n", ...
            score_acc(j), score_eff(j), score_extra(j));
    end
    ncall_list(j) = num_fcall;
end
final_score = sum(score_tot) / ntest + sum(score_extra);
disp("#####")
fprintf('Final score : %f \n', final_score);