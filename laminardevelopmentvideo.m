% === Set up video writer ===
v = VideoWriter('baseline.mp4', 'MPEG-4');
v.FrameRate = 10;  % Adjust playback speed
open(v);

% === Generate list of filenames ===
timesteps = 25000:25000:500000;
file_list = arrayfun(@(n) sprintf('Re_5e3_APG/Re_5e3.%d', n), timesteps, 'UniformOutput', false);

% === Loop through each file ===
for i = 1:length(file_list)
    fname = file_list{i};
    timestep = timesteps(i);  % time step extracted directly

    if isfile(fname)
        % === Load field data ===
        [x, y, z, xm, ym, zm, U, V, W, P, nu_t, nu] = read_field(fname);

        % === Extract U(x,y) slice (assume z=1) ===
        U_field = squeeze(U(:, :, 1));  % 2D U(x,y)

        % === Plot the field ===
        figure(1); clf;
        imagesc(x, y, U_field');  % transpose to match (x, y) axes
        set(gca, 'YDir', 'normal');
        colormap turbo;
        colorbar;
        caxis([0, 1.1]);  % adjust based on your U_inf
        xlabel('x (m)');
        ylabel('y (m)');
        title(sprintf('U(x, y) at Time Step %d', timestep));
        set(gca, 'FontName', 'Times New Roman');  % Axis tick labels
        set(gcf, 'Color', 'w'); 

        axis tight;
        drawnow;

        % === Capture and write frame ===
        frame = getframe(gcf);
        writeVideo(v, frame);
    else
        warning('File not found: %s', fname);
    end
end