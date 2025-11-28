function app = showKeyMatrix(key7,app)
                % show parity matrix
                [~, mat] = addParityBits(key7);
                % display matrix as lines of 0/1
                if ~isempty(mat)
                    lines = strings(8,1);
                    for r=1:8
                        lines(r) = strjoin(string(mat(r,:)),' ');
                    end
                    app.DESKeyTextArea.Value = lines; % uitextarea accepts string array
                end
end