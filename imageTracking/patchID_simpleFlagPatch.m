function [dataOut]=patchID_simpleFlagPatch(dataIn,val_threshold,xPatch,yPatch,texture_min,texture_max)
% Function to identify patches of size xPatch x yPatch with median variance
%   in texture_min<texture_max for gathers in DSI structure data, returning
%   DSI with new structure data{n}.P, which has 1x3 cells corresponding to 
%   the center point and patchSize of all identified patches.
%
%   output=pdfs in cwd of patch analysis (not displayed)
%
% History
%---------
% 02/25/2016 -- working
% 03/01/2016 -- mod to find patches of low variance (below val_threshold)
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
%xPatch=10; %ncol of submatrix in channels;
%yPatch=125; %nrow of submatrix in samples (#samp=#sec/samplingrate)
%texture_max=100; %patch is called an event when counts per patch > texture_max


%%

fullSize=size(dataIn{1}.dat{1});
dataOut=dataIn;
plotcount=1; %keep track of how many plots you have saved
%possible_positions=[1,6,11,16,21,26,31];

% Find values > abs(val_threshold)
for i=1:n

    clear row col val
    
    % Flag absolute vals in gather > val_threshold and plot flags on image
    A=dataIn{i}.dat{1};
    [row,col,val]=find(abs(A) > val_threshold); 
    
    % Subdivide gather into submatrices of size xPatch x yPatch 
    Asub = mat2cell(A, cat(1,repmat(yPatch,round(fullSize(1)/yPatch)-1,1),...
                            fullSize(1)-yPatch*(round(fullSize(1)/yPatch)-1)),...
                       cat(2,repmat(xPatch,1,round(fullSize(2)/xPatch)-1),...
                            fullSize(2)-xPatch*(round(fullSize(2)/xPatch)-1)));
                        
    % Recursively set median variance values
    AsubMedvar=zeros(size(Asub));
    patchcount=1;
    for r=1:size(Asub,1)
        for c=1:size(Asub,2)
            AsubMedvar(r,c)=median(var(Asub{r,c}));   
        end
    end
    
    % Search for:
    %   case1: All neighboring patches are L in time && All later patches are H
    %
    %   case2: patch with (median variance values < texture_max), AND
    %   patches below/above have (median variance values > 10*texture_max)
    %
    %
    % If you find one, then get its centerpoint location in A and
    % the patch size and put these into a new cell of the new data
    % structure P in the output. Then iterate the patchcount.
    %
    %
    %
    %
    position=1;

    for r=1:size(Asub,1)
        for c=1:size(Asub,2)
            AsubMedvar(r,c)=median(var(Asub{r,c}));    % median value of variance 
        end
    end
    
    for r=1:size(Asub,1)
        for c=3:size(Asub,2)-2

            if(AsubMedvar(r,c)<=texture_max ...
                  & AsubMedvar(r,c)>=texture_min ...
                  & AsubMedvar(r,c+1)<=texture_max ...
                  & AsubMedvar(r,c+1)>=texture_min ...
                  & AsubMedvar(r,c-1)<=texture_max ...
                  & AsubMedvar(r,c-1)>=texture_min ...
                  & AsubMedvar(r,c+2)<=texture_max ...
                  & AsubMedvar(r,c+2)>=texture_min ...
                  & AsubMedvar(r,c-2)<=texture_max ...
                  & AsubMedvar(r,c-2)>=texture_min);
            
%            if r>1 && c>4 && c<size(Asub,2)-3
                %if AsubMedvar(r,c)<texture_threshold     % if greater than texture threshold call it a patch
%              if(AsubMedvar(r,c)<=texture_max ...
%                   & AsubMedvar(r,c)>=texture_min ...
%                   & AsubMedvar(r,c+1)<=texture_max ...
%                   & AsubMedvar(r,c+1)>=texture_min ...
%                   & AsubMedvar(r,c+2)<=texture_max ...
%                   & AsubMedvar(r,c+2)>=texture_min ...
%                   & AsubMedvar(r,c+3)<=texture_max ...
%                   & AsubMedvar(r,c+3)>=texture_min ...
%                   & AsubMedvar(r,c-1)<=texture_max ...
%                   & AsubMedvar(r,c-1)>=texture_min ...
%                   & AsubMedvar(r,c-2)<=texture_max ...
%                   & AsubMedvar(r,c-2)>=texture_min ...
%                   & AsubMedvar(r,c-3)<=texture_max ...
%                   & AsubMedvar(r,c-3)>=texture_min ...
%                   & AsubMedvar(r-1,c+1)<=texture_max ...
%                   & AsubMedvar(r-1,c+1)>=texture_min ...
%                   & AsubMedvar(r-1,c+2)<=texture_max ...
%                   & AsubMedvar(r-1,c+2)>=texture_min ...
%                   & AsubMedvar(r-1,c+3)<=texture_max ...
%                   & AsubMedvar(r-1,c+3)>=texture_min ...
%                   & AsubMedvar(r-1,c-1)<=texture_max ...
%                   & AsubMedvar(r-1,c-1)>=texture_min ...
%                   & AsubMedvar(r-1,c-2)<=texture_max ...
%                   & AsubMedvar(r-1,c-2)>=texture_min ...
%                   & AsubMedvar(r-1,c-3)<=texture_max ...
%                   & AsubMedvar(r-1,c-3)>=texture_min)
       
                
            %& sum(sum(AsubMedvar(r,:)>5*texture_max))<1)
            %& sum(sum(AsubMedvar(:,:)>1000))>=3)

            %Patch is low and neighboring patch is low
            %             if(AsubMedvar(r,c)<texture_max & ...
            %                 AsubMedvar(r,c+1)<texture_max)

            %Patch is low and neighboring patch is low and next patches are high
            %             if(AsubMedvar(r,c)<texture_max & ...
            %                 AsubMedvar(r,c+1)<texture_max & ... 
            %                   (AsubMedvar(r+1,c)>texture_max | AsubMedvar(r,c+1)>texture_max))


 %               disp(i); disp('patch found')
                patchSize=size(Asub{r,c}); 
                Ay=(r-1)*yPatch+patchSize(1)/2; % where is center (Ay,Ax) of Asub{j} in A
                Ax=(c-1)*xPatch+patchSize(2)/2;
                dataOut{i}.P{patchcount}={[Ay,Ax,patchSize,AsubMedvar(r,c),position]};
                
                %plot(Ax,Ay,'kx','MarkerSize',10); 
                %plot([Ax-patchSize(2)/2,Ax+patchSize(2)/2,Ax+patchSize(2)/2,Ax-patchSize(2)/2,Ax-patchSize(2)/2],...
                %     [Ay-patchSize(1)/2,Ay-patchSize(1)/2,Ay+patchSize(1)/2,Ay+patchSize(1)/2,Ay-patchSize(1)/2],'k-');

%                 for s=1:length(possible_positions)
%                       if possible_positions(s)==position;
%                           dsi2pdf(dataOut{i},patchcount,plotcount,val_threshold,i,possible_positions(s)); %only plot if patch is in area of interest
%                           plotcount=plotcount+1; 
%                       end
%                 end
%                 
                patchcount=patchcount+1;
            end
            position=position+1;
        end
    end
    hold off;
    
disp(patchcount)
end
