function [dataOut]=patchID_simpleFlagPath_show(dataIn,val_threshold,xPatch,yPatch,texture_min,texture_max)
% Function to identify patches of size xPatch x yPatch with median variance
%   above texture_threshold for gathers in DSI structure data, returning
%   DSI with new structure data{n}.P, which has 1x3 cells corresponding to 
%   the center point and patchSize of all identified patches.
%
% History
%---------
% 02/25/2016 -- working
% 03/01/2016 -- mod to find patches of low no. of events variance (below texture_threshold)
%
%
% Potential to-do
%--------------------
% - submatrices in last col and row are weird sized
% - svd over A first before flagging for stability?
%
% NJL Feb 2016
%
        
%%
% User input

n=length(dataIn); %number of gathers to loop through, arbitrary
%val_threshold=100; %find abs(data) > val_threshold
%xPatch=100; %ncol of submatrix in channels;
%yPatch=1250; %nrow of submatrix in samples (#samp=#sec/samplingrate)
%texture_threshold=100; %patch is called an event when counts per patch > texture_threshold


%%

fullSize=size(dataIn{1}.dat{1});
dataOut=dataIn;

% Find values > abs(val_threshold)
for i=1:n

    disp(' ')
    tic
    clear row col val
    
    % Flag absolute vals in gather > val_threshold and plot flags on image
    A=dataIn{i}.dat{1};
    [row,col,val]=find(abs(A) > val_threshold);
    imagesc(A); hold on; plot(col,row,'go'); colormap(bone); 
        xlabel('channel [m]'); ylabel('time samples [0.008s]');
    set(gca,'FontSize',20);
    disp(['Gather #' num2str(i)])
    disp(['nFlags=' num2str(sum(val))])
    
    % Subdivide gather into submatrices of size xPatch x yPatch 
    Asub = mat2cell(A, cat(1,repmat(yPatch,round(fullSize(1)/yPatch)-1,1),...
                            fullSize(1)-yPatch*(round(fullSize(1)/yPatch)-1)),...
                       cat(2,repmat(xPatch,1,round(fullSize(2)/xPatch)-1),...
                            fullSize(2)-xPatch*(round(fullSize(2)/xPatch)-1)));
                        
    % Recursively look for median variance values > texture_threshold. If 
    % you find one, then get its centerpoint location in A and
    % the patch size and put these into a new cell of the new data
    % structure P in the output. Then iterate the patchcount. Make
    % AsubMedvar before scanning through for logic matches so you can look
    % in front of patch of interest.
    AsubMedvar=zeros(size(Asub));
    patchcount=1;
    for r=1:size(Asub,1)
        for c=1:size(Asub,2)
            AsubMedvar(r,c)=median(var(Asub{r,c}));    % median value of variance 
            
            patchSize=size(Asub{r,c}); 
            
            Ay=(r-1)*yPatch+patchSize(1)/2; % where is center (Ay,Ax) of Asub{j} in A
            Ax=(c-1)*xPatch+patchSize(2)/2;
            
            text(Ax,Ay,num2str(int32(AsubMedvar(r,c))),'FontSize',20); 
            
        end
    end
    
    for r=1:size(Asub,1)
        for c=3:size(Asub,2)-2
            patchSize=size(Asub{r,c}); 
            
            Ay=(r-1)*yPatch+patchSize(1)/2; % where is center (Ay,Ax) of Asub{j} in A
            Ax=(c-1)*xPatch+patchSize(2)/2;
%             
%             text(Ax,Ay,num2str(int32(AsubMedvar(r,c))),'FontSize',20); 
            

            
            %NORTH-TRACKING
%             if r>1 && c>4 && c<size(Asub,2)-3
%                 %if AsubMedvar(r,c)<texture_threshold     % if greater than texture threshold call it a patch
%                 if(AsubMedvar(r,c)<=texture_max ...
%                   & AsubMedvar(r,c)>=texture_min ...
%                   & AsubMedvar(r,c+1)<=texture_max ...
%                   & AsubMedvar(r,c+1)>=texture_min ...
%                   & AsubMedvar(r,c+2)<=texture_max ...
%                   & AsubMedvar(r,c+2)>=texture_min ...
%                   & AsubMedvar(r,c+3)<=texture_max ...
%                   & AsubMedvar(r,c+3)>=texture_min ...
%                   & AsubMedvar(r,c+4)<=texture_max ...
%                   & AsubMedvar(r,c+4)>=texture_min ...
%                   & AsubMedvar(r,c-1)<=texture_max ...
%                   & AsubMedvar(r,c-1)>=texture_min ...
%                   & AsubMedvar(r,c-2)<=texture_max ...
%                   & AsubMedvar(r,c-2)>=texture_min ...
%                   & AsubMedvar(r,c-3)<=texture_max ...
%                   & AsubMedvar(r,c-3)>=texture_min ...
%                   & AsubMedvar(r,c-4)<=texture_max ...
%                   & AsubMedvar(r,c-4)>=texture_min ...
%                   & AsubMedvar(r-1,c+1)<=texture_max ...
%                   & AsubMedvar(r-1,c+1)>=texture_min ...
%                   & AsubMedvar(r-1,c+2)<=texture_max ...
%                   & AsubMedvar(r-1,c+2)>=texture_min ...
%                   & AsubMedvar(r-1,c+3)<=texture_max ...
%                   & AsubMedvar(r-1,c+3)>=texture_min ...
%                   & AsubMedvar(r-1,c+4)<=texture_max ...
%                   & AsubMedvar(r-1,c+4)>=texture_min ...
%                   & AsubMedvar(r-1,c-1)<=texture_max ...
%                   & AsubMedvar(r-1,c-1)>=texture_min ...
%                   & AsubMedvar(r-1,c-2)<=texture_max ...
%                   & AsubMedvar(r-1,c-2)>=texture_min ...
%                   & AsubMedvar(r-1,c-3)<=texture_max ...
%                   & AsubMedvar(r-1,c-3)>=texture_min ...
%                   & AsubMedvar(r-1,c-4)<=texture_max ...
%                   & AsubMedvar(r-1,c-4)>=texture_min)
              
                  %SOUTH-TRACKING
%            if r>1 && r<size(Asub,1) && c>1 && c<size(Asub,2) 
%                 %if AsubMedvar(r,c)<texture_threshold     % if greater than texture threshold call it a patch


             if c>1 && c<size(Asub,2)
                 if(AsubMedvar(r,c)<=texture_max/2 ...
                  & AsubMedvar(r,c)>=texture_min ...
                  & AsubMedvar(r,c+1)<=texture_max ...
                  & AsubMedvar(r,c+1)>=texture_min ...
                  & AsubMedvar(r,c-1)<=texture_max ...
                  & AsubMedvar(r,c-1)>=texture_min ...
                  & AsubMedvar(r,c+2)<=texture_max ...
                  & AsubMedvar(r,c+2)>=texture_min ...
                  & AsubMedvar(r,c-2)<=texture_max ...
                  & AsubMedvar(r,c-2)>=texture_min)

            
                  dataOut{i}.P{patchcount}={[Ay,Ax,patchSize]};
                  %plot(Ax,Ay,'kx','MarkerSize',10); 
                  plot([Ax-patchSize(2)/2,Ax+patchSize(2)/2,Ax+patchSize(2)/2,Ax-patchSize(2)/2,Ax-patchSize(2)/2],...
                     [Ay-patchSize(1)/2,Ay-patchSize(1)/2,Ay+patchSize(1)/2,Ay+patchSize(1)/2,Ay-patchSize(1)/2],'k-');
                  patchcount=patchcount+1;
                end
            end
        end
    end
    hold off;
    disp(['nPatches=' num2str(patchcount-1)])
    toc
    pause
end
