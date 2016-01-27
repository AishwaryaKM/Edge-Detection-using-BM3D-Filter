function ok = checkattributes(a, classes, attributes)

try
    validateattributes(a, classes, attributes, 'checkattributes');
    ok = true;
catch ME
    if ~isempty(strfind(ME.identifier, ':checkattributes:'))
        ok = false;  % first argument failed the specified tests
    else
        rethrow(ME); % there was some other error
    end
end
end