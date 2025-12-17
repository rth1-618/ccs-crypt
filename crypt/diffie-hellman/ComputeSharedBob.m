function ComputeSharedBob(app)

    if app.DH.A<=0
        app.UI.('DiffHellPanel').Status.Text = 'A or b not set';
        uialert(app.UIFigure,'Not received A from Alice yet OR b is empty','Error');
        return;
    end

    S_B = powmod(app.DH.A, app.DH.b, app.DH.p);
    app.DH.S_B = S_B;

    app.BobSharedLabel.Text   = num2str(S_B);

    if app.DH.S_A > 0
        if app.DH.S_A == S_B
            msg = 'Shared secret MATCH!!';
        else
            msg = 'Mismatch!!';
        end
   
         app.UI.('DiffHellPanel').Status.Text = msg;
    end
end
