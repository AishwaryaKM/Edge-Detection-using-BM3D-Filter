function [g, region] = gradients_n(a, varargin)


% check arguments and get defaults
[sigmas, wraps, region, regonly, d, symdiff, dmargin] = ...
    checkinputs(a, varargin{:});

% can stop now if only the region to be returned
if regonly
    g = region;
    return;
end
    
% expand the region to allow for subsequent differencing operation
regdiff = region + repmat(dmargin, 1, d);

% region selection and spatial smoothing (do this before sum and difference
% to reduce processing if region is small)
asmth = gsmoothn(a, sigmas, 'Region', regdiff, 'Wrap', wraps);

% Differencing mask
if symdiff
    % get the average gradient over 2 voxels so centred
    dmask = [1; 0; -1]/2;
    % Index ranges for trimming undifferenced dimensions
    sz = size(asmth);
    sz = sz(1:d);     % omit trailing 1 in 1-D case
    triminds = arrayfun(@(x) 2:x-1, sz, 'UniformOutput', false);
else
    % take adjacent voxels, not centred on voxel
    dmask = repmat([1; -1]/(2^(d-1)), [1 2+zeros(1,d-1)]);
end

g = cell(1, d);
perm = (1:max(2,d)).';   % permute needs at least 2 dimensions to order

for i = 1:d
    
    % orient mask along current dimension
    dmaskr = permute(dmask, circshift(perm, i-1));
    
    if symdiff
        % trim other dimensions so outputs all same size
        t = triminds;
        t{i} = 1:sz(i);        %
        g{i} = convn(asmth(t{:}), dmaskr, 'valid');
    else
        g{i} = convn(asmth, dmaskr, 'valid');
    end
    
    
end

end

% -------------------------------------------------------------------------

function [sigmas, wraps, region, regonly, d, symdiff, dmargin] = ...
    checkinputs(a, varargin)
% Check arguments and get defaults

% Most checking done in gsmoothn, no need here
inp = inputParser;
inp.addOptional('sigma', 0);
inp.addOptional('regonly', '', @(s) strcmp(s, 'RegionOnly'));
inp.addParamValue('Region', []);
inp.addParamValue('Wrap', []);
inp.addParamValue('Centred', true);
inp.parse(varargin{:});
regonly = ~isempty(inp.Results.regonly);
sigmas = inp.Results.sigma;
region = inp.Results.Region;
wraps = inp.Results.Wrap;
symdiff = inp.Results.Centred;

% number of dimensions, defined as number of last non-singleton dimension
if iscolumn(a)
    d = 1;
else
    d = ndims(a);
end

if isempty(wraps)
    wraps = false(1, d);
elseif isscalar(wraps)
    wraps = repmat(wraps, 1, d);
end

if symdiff
    dmargin = [-1 1];   % region margin for differencing
else
    dmargin = [-1 0];
end

if isempty(region) || strcmp(region, 'valid')
    % default region - small enough not to need extrapolation
    region = gsmoothn(a, sigmas, 'RegionOnly', 'Wrap', wraps);
    % -dmargin because contracting to get output region
    region = region + ...
        repmat(-dmargin, 1, d) .* double(~reshape([wraps; wraps], 1, 2*d));
elseif strcmp(region, 'same')
    sz = size(a);
    region = reshape([ones(1, d); sz(1:d)], 1, 2*d);
end
if any(region(2:2:end) < region(1:2:end))
    error('DavidYoung:gradients_n:badreg', ...
        'REGION or array size too small');
end

end

