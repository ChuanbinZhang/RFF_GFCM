function [Z, Z1] = RFF(X, gamma, n_components, re)
[h, w, D] = size(X);
X = reshape(X, [h * w, D]);
if re > 0
    W = gamma * randn(D, n_components);
    B = 2 * pi * rand(1, n_components);
    projection = X * W + B;
    Z1 = sqrt(2. / n_components) * cos(projection);
    Z = reshape(Z1, [h, w, n_components]);
else
    W = gamma * randn(D, n_components);
    projection = X * W;
    Z1 = sqrt(1. / n_components) * [sin(projection) cos(projection)];
    Z = reshape(Z1, [h, w, 2 * n_components]);
end

