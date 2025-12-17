function ComputeSharedAlice(app)

    if app.DH.B<=0 
        app.UI.('DiffHellPanel').Status.Text = 'B or a not set';
        uialert(app.UIFigure,'Not received B from Bob yet OR a is empty','Error');
        return;
    end

    S_A = powmod(app.DH.B, app.DH.a, app.DH.p);
    app.DH.S_A = S_A;

    app.AliceSharedLabel.Text = num2str(S_A);

    if app.DH.S_B > 0
        if S_A == app.DH.S_B
            msg = 'Shared secret MATCH!!';
        else
            msg = 'Mismatch!!';
        end
   
         app.UI.('DiffHellPanel').Status.Text = msg;
    end
end
