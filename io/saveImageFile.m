function saveImageFile(app, panelName)
    ui = app.UI.(panelName);
    if isempty(app.outputImage)
        uialert(app.UIFigure,'No output image to save','Error'); return;
    end
    [f,p] = uiputfile({'*.png';'*.jpg'}, 'Save Image As');
    if isequal(f,0), return; end
    outpath = fullfile(p,f);
    try
        imwrite(app.outputImage, outpath);
        ui.Status.Text = 'Image saved';
    catch
        uialert(app.UIFigure,'Failed to save image','Error');
    end
end
