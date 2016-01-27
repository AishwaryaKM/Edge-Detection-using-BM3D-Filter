function t = fractile(x, f)

%   T = FRACTILE(X, F) finds a value T for which a fraction F of the
%   elements of X are less than T. A fractile is like a centile.


validateattributes(x, {'numeric'}, {});
validateattributes(f, {'numeric'}, {'>=' 0 '<=' 1});

x = sort(x(:));
n = numel(x);
fn = n * f(:);      % the ideal index into sorted g

i = floor(fn + 0.5);        % index of value just less than f

ga = x(max(i, 1));
gb = x(min(i+1, n));

r = fn + 0.5 - i;
t = (1-r) .* ga + r .* gb;    % interpolate

t = reshape(t, size(f));

end
