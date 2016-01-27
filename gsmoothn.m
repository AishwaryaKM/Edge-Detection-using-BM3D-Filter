function [a, reg] = gsmoothn(a, sigmas, varargin)
       

[sigmas, bcons, reg, convreg, ronly, d] = ...
    checkinputs(a, sigmas, varargin{:});

if ronly
    a = reg;
else
    if ~isempty(convreg)            % trim/pad array
        lims = mat2cell(convreg, 1, repmat(2, 1, d));
        lims = cellfun(@(x) x(1):x(2), lims, 'UniformOutput', false);
        indargs = cell(1, 2*d);
        indargs(1:2:end) = lims;
        indargs(2:2:end) = bcons;
        
        a = exindex(a, indargs{:});
    end
    for i = 1:d
        a = gsmooth1(a, i, sigmas(i));
    end
end

end

% -------------------------------------------------------------------------

function [sigmas, bcons, reg, convreg, regonly, d] = ...
    checkinputs(a, sigmas, varargin)
% Check arguments and get defaults, plus input/output convolution regions
% and boundary conditions

% array argument
validateattributes(a, {'double' 'single'}, {}, mfilename, 'a');

% number of dimensions, defined as number of last non-singleton dimension
if iscolumn(a)
    d = 1;
else
    d = ndims(a);
end

% sigmas argument
validateattributes(sigmas, {'double'}, {'nonnegative' 'real' 'vector'}, ...
    mfilename, 'sigmas');
if isscalar(sigmas)
    sigmas = repmat(sigmas, 1, d);
elseif ~isequal(length(sigmas), d)
    error('DavidYoung:gsmoothn:badsigmas', 'SIGMAS wrong size');
end

inp = inputParser;
inp.addOptional('regonly', '', @(s) strcmp(s, 'RegionOnly'));
% no need for region elements to be positive
inp.addParamValue('Region', [], @(r) ...
    isempty(r) || ...
    (ischar(r) && ismember(r, {'valid' 'same'})) || ...
    checkattributes(r, {'numeric'}, {'integer' 'size' [1 2*d]}));
inp.addParamValue('Wrap', [], @(w) ...
    isempty(w) || ...
    (islogical(w) && (isscalar(w) || isequal(size(w), [1 d]))));
inp.parse(varargin{:});

% wraps argument
wraps = inp.Results.Wrap;
if isempty(wraps)
    wraps = false(1, d);
elseif isscalar(wraps)
    wraps = repmat(wraps, 1, d);
end
boundopts = {'symmetric' 'circular'};
bcons = boundopts(wraps+1);

% region argument
regonly = ~isempty(inp.Results.regonly);
reg = inp.Results.Region;

% whole array region
sz = size(a);
imreg = reshape([ones(1, d); sz(1:d)], 1, 2*d);

% convolution margins and wrap multipliers
mrg = gausshsize(sigmas);
mrg = reshape([mrg; -1*mrg], 1, 2*d);

if isempty(reg) || strcmp(reg, 'valid')
    % default region - small enough not to need extrapolation - shrink on
    % non-wrapped dimensions
    reg = imreg + mrg .* double(~reshape([wraps; wraps], 1, 2*d));
elseif strcmp(reg, 'same')
    reg = imreg;
end
if any(reg(2:2:end) < reg(1:2:end))
    error('DavidYoung:gsmoothn:badreg', 'REGION or array size too small');
end
% compute input region for convolution - expand on all dimensions
convreg = reg - mrg;    % expand
if isequal(convreg, imreg)
    convreg = [];   % signal no trimming or padding
end

end

% -------------------------------------------------------------------------

function a = gsmooth1(a, dim, sigma)
% Smooth an array A along dimension DIM with a 1D Gaussian mask of
% parameter SIGMA

if sigma > 0
    mlen = 2*gausshsize(sigma) + 1;  % reasonable truncation    
    mask = fspecial('gauss', [mlen 1], sigma);
    msize = ones(1, ndims(a));
    msize(dim) = mlen;
    mask = reshape(mask, msize);
    
    a = convn(a, mask, 'valid');
end

end

% -------------------------------------------------------------------------

function hsize = gausshsize(sigma)
% Default for the limit on a Gaussian mask of parameter sigma.
% Produces a reasonable degree of truncation without too much error.
hsize = ceil(2.6*sigma);
end

