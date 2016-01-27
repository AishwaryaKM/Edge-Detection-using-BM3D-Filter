function [e, thresh] = canny(im, varargin)



% Sort arguments. Most checking done by other functions.
inp = inputParser;
checkthresh = @(t) checkattributes(t, {'numeric'}, ...
    {'nonnan' 'real' 'finite' 'nonnegative' 'nondecreasing'}) && ...
    (isempty(t) || isscalar(t) || isequal(size(t), [1 2]));
inp.addOptional('sigma', 0);
inp.addOptional('thresh', [], checkthresh);
inp.addParamValue('Region', 'same');
inp.addParamValue('Centred', true);
inp.addParamValue('SMethod', 'boundary');
inp.addParamValue('SRadius', 1);
inp.addParamValue('TMethod', 'none')
inp.addParamValue('TValue', [], checkthresh)
inp.addParamValue('TRatio', [], @(t) isempty(t) || ...
    checkattributes(t, {'numeric'}, ...
    {'nonnan' 'real' 'nonnegative' 'scalar' '<=' 1}));
inp.addParamValue('TConn', []);
inp.addParamValue('SubPixel', false);
inp.parse(varargin{:});

sigma = inp.Results.sigma;
if isempty(sigma)
    sigma = sqrt(2);        % default for IPT edge function
end

% smoothing
g = gradients_n(im, sigma, ...
    'Region', inp.Results.Region, 'Centred', inp.Results.Centred);

% non-maximum suppression
[e, gMag] = nonmaxSuppress(g, 'Method', inp.Results.SMethod, ...
    'Radius', inp.Results.SRadius, 'SubPixel', inp.Results.SubPixel);

% correct for offset if sub-pixel estimate with offset gradients
if inp.Results.SubPixel && ~inp.Results.Centred
    e.subpix = cellfun(@(a) a-0.5, e.subpix, 'UniformOutput', false);
end

% hysteresis thresholding
[tmeth, thresh, tratio, tconn] = threshargs(inp);

if ~strcmp(tmeth, 'none')
    thresh = findThreshold(gMag, tmeth, thresh, tratio);
    if inp.Results.SubPixel
        e.edge = hystThresh(e.edge, gMag, thresh, tconn);
    else
        e = hystThresh(e, gMag, thresh, tconn);
    end
end

end


function [tmeth, thresh, tratio, tconn] = threshargs(inp)
% Sort out threshold argument and name-value pairs

if ~ismember('thresh', inp.UsingDefaults)    % simple threshold argument

    if ~all(ismember({'TMethod' 'TValue' 'TRatio' 'TConn'}, ...
            inp.UsingDefaults))
        error('DavidYoung:canny:threshargs', ...
            'Threshold name-value pairs used with threshold argument');
    end
    thresh = inp.Results.thresh;
    if isempty(thresh)
        % defaults as per IPT edge function
        tmeth = 'histogram';
        thresh = 0.7;
        tratio = 0.4;
    else
        % interpret consistently with IPT edge function
        tmeth = 'relMax';
        if isscalar(thresh)
            tratio = 0.4;
        else
            tratio = [];
        end
    end
    tconn = {};
    
else                                    % name-value pairs
    
    tmeth = inp.Results.TMethod;
    thresh = inp.Results.TValue;
    tratio = inp.Results.TRatio;
    tconn = inp.Results.TConn;
    
    if ~strcmp(tmeth, 'none') && isempty(thresh)
        error('DavidYoung:canny:noThresholdValue', ...
            'Threshold method set but no threshold value');
    end
    
end

end


function t = findThreshold(g, method, val, tratio)
% Returns a threshold value for edge detection

switch method
    case 'absolute'
        t = val;
    case 'relMax'
        t = val * max(g(:));
    case 'histogram'
        if ~isscalar(val)
            error('DavidYoung:canny:lowThreshHistogram', ...
                'Low threshold set explicitly with histogram option');
        end
        t = fractile(g, val);
    otherwise
        error('DavidYoung:canny:badThreshMethod', ...
            'Unknown threshold method %s', method);
end

if ~isempty(tratio)
    if isscalar(t)
        t = [tratio*t t];
    else
        error('DavidYoung:canny:redundantThresholds', ...
            'Ratio and low and high thresholds all specified');
    end
end

end
