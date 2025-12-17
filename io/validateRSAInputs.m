function validateRSAInputs(app)
    p = app.pEditField.Value;
    q = app.qEditField.Value;

    validP = isprime(p);
    validQ = isprime(q);

    % Inline errors
    app.pStatusLabel.Text = ternary(validP,'','Not prime');
    app.qStatusLabel.Text = ternary(validQ,'','Not prime');

    if p == q
        uialert(app.UIFigure,'p and q cannot be same','Error'); return;
    end

    if validP && validQ && p ~= q
        n = p*q;
        phi = (p-1)*(q-1);

        app.RSA.p = p;
        app.RSA.q = q;
        app.RSA.n = n;
        app.RSA.phi = phi;

        app.nLabel.Text = strcat('n = ', num2str(n));

        % Populate e dropdown
        eList = generateEList(phi);
        app.eDropDown.Items = string(eList);
        app.eDropDown.Value = string(eList(1));
        app.eDropDown.Enable = 'on';
        app.GenerateKeysButton.Enable = 'on';
    else
        app.GenerateKeysButton.Enable = 'off';
        app.eDropDown.Enable = 'off';
        app.nLabel.Text = 'n = ---';
    end
end

function out = ternary(cond,a,b)
    if cond, out = a; else, out = b; end
end