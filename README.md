Math 128A Spring 2025 Final Project, UC Berkeley, Professor Ming Gu

Modified zero-in for root finding (on polynomials on specified intervals).

Given Conditions: function f(a), interval [a, b] and f(a) * f(b) < 0 (Intermediate Value Theorem - existence of root), tolerance TOL
Return: root or failure

The function utilizes inverse quadratic interpolation (IQI) for its higher order of convergence.
But if IQI calculates an estimate of x outside of [a, b] or the absolute value of the estimate does not decrease by a factor of two, then we perform one iteration of bisection method to move the root finding forward.

This MATLAB function was created and optimized for the least amount of calls to function f.

- routine_test_final.m  (test file created by GSI)
- modifiedzeroinxxx.m   (my solution file)
- MA128A...             (instruction file)
