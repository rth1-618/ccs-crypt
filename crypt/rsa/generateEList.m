function eList = generateEList(phi)
% GENERATEELIST  Valid e values where gcd(e,phi)=1

    candidates = [3 5 17 257 65537];
    eList = [];

    % for e = candidates
    %     if e < phi && gcd(e,phi) == 1
    %         eList(end+1) = e; %#ok<AGROW>
    %     end
    % end

    % fallback: brute small e
    if isempty(eList)
        for e = 3:2:phi-1
            if gcd(e,phi) == 1
                eList(end+1) = e; %#ok<AGROW>
            end
        end
    end
end
