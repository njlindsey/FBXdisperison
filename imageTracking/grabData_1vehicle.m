%%

clear figure filt_clean

%open new dsi to map to, and setup threshold for maximum variance
threshold=5000;
goodones=1;

%make rect for moving avg
rect = [0.5;repmat(1,50,1);0.5];

for i=1:size(filt,2)
    
    F=filt{i}.dat{1};
    V=var(F');
    
    SN=min(V)/max(V)
    BW=find(SN<0.001)
    
    b=find([diff(BW) inf]>1);
    L=diff([0 b]);
    E=cumsum(L);
    
    %V(i)=max(var(filt{i}.dat{1}'));
    if max(var(filt{i}.dat{1}'))<threshold % if max variance across gather is low
        
        
       % R=find(var(filt{i}.dat{1})<minthreshold & var(filt{i}.dat{1}')<maxthreshold,1) % grab first index when 
        
        
       % if R<length(filt{1}.dat{1})-(5/0.008)
            
            
        %    filt_clean{goodones}.dat{1}=filt{i}.dat{1}(R:R+(5/0.008),:)
        %    goodones=goodones+1;
        %    

        %end
        
        filt_clean{goodones}.dat{1}=filt{i}.dat{1};
        goodones=goodones+1;
        
    end
    
end

% for i=1:size(filt_clean,2)
%     filt_clean{i}.fh{8}=0.0080;
%     filt_clean{i}.fh{9}=0;
%     filt_clean{i}.fh{10}=59;
%     filt_clean{i}.th{1}=filt{1}.th{1};
% end



%make figs for best goodones
subplot_index=1;
for j=1:5;%size(filt_clean,2)
%     subplot(4,size(filt_clean,2)/4,subplot_index)
%     imagesc(filt_clean{j}.dat{1}')
%     colormap(jet)

     for r=1:length(filt{i}.dat{1})
         s(r)=abs(max(filt{i}.dat{1}(r,:),2)/min(filt{i}.dat{1}(r,:),2));
     end

%     subplot(3,9,subplot_index+9)
%     semilogy(s,'go'); hold on
%     semilogy(b,'LineWidth',2)
%     %plot(s,'go'); hold on
% 	%plot(b,'LineWidth',2)
%     plot(linspace(0,length(s),2),[0.01,0.01],'r--','LineWidth',2)
%     ylim([.001,1])
%     hold off
    subplot(5,2,subplot_index)
    imagesc(filt_clean{j}.dat{1})
    colormap(bone)
    ylim([0,length(filt_clean{j}.dat{1})])
    set(gca,'Fontsize',18)
    set(gca,'YTick',[0,2000,4000,6000],'YTickLabel',[0,2,4,6])
    if subplot_index==9
        xlabel('Channel Offset [meters]')
        ylabel('Time [seconds]')
    end
     
    
    subplot(5,2,subplot_index+1)
    semilogy(flipud(var(filt_clean{j}.dat{1}')),'r-'); hold on
    semilogy(flipud(conv(var(filt_clean{j}.dat{1}'),rect,'valid')),'b-');
    view(-90,90)
    set(gca,'Ydir','reverse')
    set(gca,'Xdir','reverse')
    set(gca,'Fontsize',18)
    %plot(linspace(0,length(s),2),[threshold,threshold],'k--','LineWidth',2)
    xlim([0,length(filt_clean{j}.dat{1})])
    set(gca,'XTick',[0,2000,4000,6000],'XTickLabel',[0,2,4,6])
    if subplot_index==9
        ylabel('Amplitude Variance')
        xlabel('Time [seconds]')
    end
    
    
    subplot_index=subplot_index+2;

end

