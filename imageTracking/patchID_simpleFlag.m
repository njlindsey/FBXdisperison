function patchID_simpleFlag(data,val_threshold)

n=60; %number of gathers to loop through, arbitrary
%val_threshold=100; %find abs(data) > val_threshold

%%
% Find values > abs(val_threshold)
disp('Simple Search')
for i=1:n
    tic
    clear row col val
    [row,col,val]=find(abs(data{i}.dat{1}) > val_threshold);
    imagesc(data{i}.dat{1}); hold on; plot(col,row,'go'); colormap(bone); 
        xlabel('channel [m]'); ylabel('time samples [0.08s]'); hold off;
    disp(sum(val))
    toc
    pause
end
