function patchID_svdPatchFlag(data,val_threshold,k)

n=60; %number of gathers to loop through, arbitrary
%val_threshold=100; %find abs(data) > val_threshold
%k=2; % rank of new matrix from svd image compression
xPatch=200; %ncol of submatrix in channels;
yPatch=500; %nrow of submatrix in samples (#samp=#sec/samplingrate)
texture_threshold=20; %patch is called an event when counts per patch > texture_threshold

%%
% Compress to rank-k w/ svd; 
% Break into smaller submatrix patches of size(xPatch,yPatch)
% For each patch, Find values > abs(val_threshold)
% Save patch as new data structure if nval_per_patch>texture_threshold
% textures that have >patches above threshold
disp('SVD recursive')

for i=1:n
    tic
    clear dsi row col val U S V Ak
    [U,S,V] = svd(data{i}.dat{1});
    Ak = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';
    [row,col,val]=find(abs(Ak) > threshold);
    %subplot(2,1,2); imagesc(Ak); hold on; plot(col,row,'go'); hold off
    colormap(bone); hold off;
    AkSub = mat2cell(Ak, cat(1,repmat(500,14,1),376), cat(2,repmat(50,1,10),1));
    
end

