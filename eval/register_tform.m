function warps = register_tform(folder)
% REGISTER_TFORM register all images in a folder with the first one using matlab default alignment algorithm.

im_files = dir([folder '/*.png']);

folder = im_files(1).folder;
im_ref_file = [folder '/' im_files(1).name];
im_ref = imread(im_ref_file);
% imwrite(im_ref, ['out/', im_files(1).name]);

% [optimizer, metric] = imregconfig('multimodal');
[optimizer, metric] = imregconfig('monomodal');

nb_files = length(im_files);
warps = repmat([1 0 0 1 0 0], nb_files, 1);
for i = 2:nb_files
	name = im_files(i).name;
	im_mov_file = [folder '/' name];
	% disp(im_mov_file);
	im_mov = imread(im_mov_file);

	% Compute registration
	warp = imregtform(im_mov, im_ref, 'affine', optimizer, metric, 'PyramidLevels', 1);
	warp_params = transpose(warp.T(:,1:2));
	warp_params = transpose(warp_params(:));
	warps(i,:) = warp_params;

	% Save registered image
	% im_registered = imwarp(im_mov, warp, 'OutputView',imref2d(size(im_ref)));
	% imwrite(im_registered, ['out/' name]);
end

end % function
