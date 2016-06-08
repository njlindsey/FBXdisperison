function patchID_svdFlag(data,val_threshold,k)

n=60; %number of gathers to loop through, arbitrary
%val_threshold=100; %find abs(data) > val_threshold
%k=2; % rank of new matrix from svd image compression

%%
% Compress to rank-k w/ svd; 
% Find values > abs(val_threshold)
disp('SVD')
for i=1:n
    tic
    clear U S V Ak row col val
    [U,S,V] = svd(data{i}.dat{1});
    Ak = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';
    [row,col,val]=find(abs(Ak) > val_threshold);
    imagesc(data{i}.dat{1}); hold on; plot(col,row,'bo'); colormap(bone);
     xlabel('channel [m]'); ylabel('time samples [0.08s]'); hold off;
    disp(sum(val))
    toc
    pause
end