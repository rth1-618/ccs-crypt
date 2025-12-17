function out = normalizeTextInput(val)
% NORMALIZETEXTINPUT
% Converts App Designer text inputs into a clean char row.
%
% Handles:
%   - TextArea.Value (cell array)
%   - EditField.Value (char / string)
%   - string
%   - char
%
% Output:
%   - char row vector

    if isempty(val)
        out = '';
        return;
    end

    % TextArea → cell array of lines
    if iscell(val)
        out = strjoin(val, newline);

    % string scalar
    elseif isstring(val)
        out = char(val);

    % char already
    elseif ischar(val)
        out = val;

    else
        error('normalizeTextInput:UnsupportedType', ...
              'Unsupported input type: %s', class(val));
    end
end
