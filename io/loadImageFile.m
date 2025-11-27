function loadImageFile(app, panelName)
    ui = app.UI.(panelName);
    [f,p] = uigetfile({'*.png;*.jpg;*.jpeg;*.bmp','Image Files'});
    if isequal(f,0), return; end
    full = fullfile(p,f);
    try
        img = imread(full);
    catch
        uialert(app.UIFigure,'Cannot read image','Error'); return;
    end
    app.currentImage = img;
    ui.InputPath.Value = full;    % show path in input field (non-editable in image mode)
    app.outputImage = [];
    % preview loaded image in panel preview
    % ui.PreviewText.Visible = 'off';
    ui.PreviewAxes.Visible = 'on';
    imshow(app.currentImage, 'Parent', ui.PreviewAxes);
    ui.Status.Text = 'Image loaded';
end
