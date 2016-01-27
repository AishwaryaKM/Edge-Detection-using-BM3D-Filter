function [e, gMag] = nonmaxSuppress(varargin)

%   E = NONMAXSUPPRESS(G, NAME, VALUE, ...) finds directional local maxima
%   in a gradient array, as used in the Canny edge detector, but made
%   separately accessible here for greater flexibility.
%
%   [E, GMAG] = NONMAXSUPPRESS(G, NAME, VALUE, ...) also returns an array
%   containing the magnitude of the gradient at each point.

% Argument sorting out
inp = inputParser;
inp.addRequired('g', ...
    @(g) validateattributes(g, {'cell'}, {'vector'}));
inp.addParamValue('Method', 'boundary', ...
    @(s) ismember(s, {'boundary' 'linear' 'nearest' 'cubic' 'spline'}));
inp.addParamValue('Radius', 1, ...
    @(s) validateattributes(s, {'numeric'}, ...
    {'real' 'positive', 'nonnan', 'finite', 'scalar'}));
inp.addParamValue('SubPixel', false, ...
    @(s) validateattributes(s, {'logical'}, {'scalar'}));
inp.parse(varargin{:});
g = inp.Results.g;
method = inp.Results.Method;
rad = inp.Results.Radius;

% Get and check no. dimensions. Currently only to 2 or 3-D, but could
% generalise to N if needed.
ndim = length(g);
if ndim < 2 || ndim > 3
    error('DavidYoung:nonmaxSuppression:dimsNot2or3', ...
        'Length of gradients array must be 2 or 3, was %d', ndim);
end

% make the gradients into an array
gcomps = cell2cols(g);

% compute gradient magnitude array
gMagCol = sqrt(sum(gcomps.^2, 2));
gMag = reshape(gMagCol, size(g{1}));

% convert gradients to offsets
if strcmp(method, 'boundary')
    % Make largest offset 1 - on boundary of square or cube.
    % Might expect that specialised code would be faster than general
    % interpolation in this case. Not so.
    [~, maxgradcomp] = max(abs(gcomps), [], 2);
    gnorm = gcomps(...
        sub2ind(size(gcomps), (1:size(gcomps,1)).', maxgradcomp));
    method = 'linear';   % linear interp on square or cube boundary
else
    % put on sphere of given radius
    gnorm = gMagCol / rad;
end
gcomps = bsxfun(@rdivide, gcomps, gnorm);

% coords of data points in same format
coords = arrayfun(@(s) 1:s, size(gMag), 'UniformOutput', false);
[coords{:}] = ndgrid(coords{:});
coords = cell2cols(coords);

% get interpolant
interpolant = griddedInterpolant(gMag, method);

% interpolate in gradient direction and its opposite
ginta = interpolant(coords + gcomps);
gintb = interpolant(coords - gcomps);

% suppress nonmax pixels
ok = gMag(:) >= ginta & gMag(:) >= gintb;

edges = reshape(ok, size(gMag));

if inp.Results.SubPixel
    e.edge = edges;
    e.subpix = subpix(gMag, ginta, gintb, ok, coords, gcomps);
else
    e = edges;
end

end


function a = cell2cols(c)
% put the arrays in cell array c into the columns of a
a = cell2mat(cellfun(@(x) x(:), c, 'UniformOutput', false));
end


function pos = subpix(gMag, ginta, gintb, ok, coords, gcomps)
% points on parabola
q = gMag(ok);
r = ginta(ok) - q;    % point in direction of gradient
p = gintb(ok) - q;    % opposite direction to gradient
offset = (p-r)./(2*(p+r)); % scalar offset of peak 
offset = bsxfun(@times, offset, gcomps(ok, :)); % vector offset of peak
offcoords = coords(ok, :) + offset;
res = zeros(size(gMag));
for i = 1:size(coords,2)
    res(ok) = offcoords(:, i);
    pos{i} = res;
end
end
