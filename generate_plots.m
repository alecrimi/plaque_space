% This script loads data from a series of folders, performs dimensionality reduction (T-SNE) and plot the first 2 components.
%
% A. Crimi 2019
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Param settings
folders_list={'AB_old','AB_young','LCP_old','LCP_young','BACE1_old','BACE1_young'}; %

%Change this to change the used features
feature_name = 'sizes' ;   
%feature_name = 'intensities'; 

%This should be defined automatically, but in the data produced by  Ehsan Dadgar-Kiani, the max projection was always giving data of this size 
datasize_maxproj = 5250; 
datasize = 58464;  
datapoints =  zeros(29*2, datasize_maxproj  );     %58464  69564  5250

%sorting = {'default'};
%sorting = {'default','max_proj'};
sorting = {'max_proj'};

disp('Remember the stochastic nature of T-SNE, run the algorithm several times to see different results');
tsne_repetitions = 5;
perplexity_values = [ 5 10];        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Core Script

%For all sorting
for ss = 1 : length(sorting)

     alg = sorting{ss};
     if( strcmp(alg,'max_proj'))
       datapoints =  zeros(length(list),  datasize_maxproj );     %58464  69564
     else
       datapoints =  zeros(length(list),  datasize );     %58464  69564 
     end

% Loading data
%For all channels
    % In the current version, channel 1 is the template, therefore we should do only channel 2
    for channel = 2 : 2
    count = 1;
      for ll = 1 : length(folders_list)
          ll
        %All Cases
        list = dir(strcat(folders_list{ll},'/treated'));
        for k = 3 : length(list) %Skiup empty folder
           
            if( strcmp(alg,'max_proj'))
                  datapoints(count,:) =  load_tiff_maxproj( strcat(folders_list{ll}, '/treated/' ,list(k).name,'/whole/cells_heatmap_',feature_name ,'_mean_15px.tif'),channel) ;
            else
                  datapoints(count,:) =  load_tiff( strcat(folders_list{ll}, '/treated/' ,list(k).name,'/whole/cells_heatmap_',feature_name ,'_mean_15px.tif'),channel) ;
            end
            count = count + 1;
        end
        
        %All Control
        list = dir(strcat(folders_list{ll},'/CTRL'));
        for k = 3 : length(list) %Skiup empty folder
 
            if( strcmp(alg,'max_proj'))
                  datapoints(count,:) =  load_tiff_maxproj( strcat(folders_list{ll}, '/CTRL/' ,list(k).name,'/whole/cells_heatmap_',feature_name ,'_mean_15px.tif'),channel) ;
            else
                  datapoints(count,:) =  load_tiff( strcat(folders_list{ll}, '/CTRL/' ,list(k).name,'/whole/cells_heatmap_',feature_name ,'_mean_15px.tif'),channel) ; %_sizes
            end
            count = count + 1;
        end
        
        
      end
        %{
        % PCA part, computed in different ways. For the moment put aside as it was not performing well
        %Center mean
        %Compute cov matrix
        covmat = cov(datapoints);
        %Eigendecomposition covmatrix
        [V,D] = eig(covmat);
        %Project using only the first 2 vector
        score = V(:,1:2)'*datapoints';
        figure
        hold on
        plot(score(1,1:3),score(2,1:3),'b*')
        plot(score(1,4:11),score(2,4:11),'g*')
        plot(score(1,12:16),score(2,12:16),'r*')
        plot(score(1,17:19),score(2,17:19),'y*')
        plot(score(1,20:23),score(2,20:23),'k*')
        plot(score(1,24:30),score(2,24:30),'m*')
        hold off
        box on
        xlabel('First component')
        ylabel('Second component')
        lgd = legend(list(1).name,list(2).name,list(3).name,list(4).name,list(5).name,list(6).name);
        saveas(gcf,['PCA_val_'  folder '_ch' num2str(channel) '_sorting' alg '.png'])
      %}
   
        % T-sne
        
        % For all perplexity values
        for hh = 1 : length(perplexity_values)
        
        % For all stochastic repetitions
        for jj = 1 : tsne_repetitions
             score = tsne(datapoints,'Algorithm','exact','Distance','euclidean','Perplexity',perplexity_values(hh));
             score = score';
 
             %Plot OLD groups
             % Assure that order matches the list provided at the begining of the script
             % Improvement: set those numbers automatically!
             figure
             hold on
             plot(score(1,1:3),score(2,1:3),'b*')
             plot(score(1,10:13),score(2,10:13),'r*')
             plot(score(1,20:24),score(2,20:24),'k*')
             plot(score(1,28:33),score(2,28:33),'bo')
             plot(score(1,38:41),score(2,38:41),'ro')
             plot(score(1,48:51),score(2,48:51),'ko')
             hold off
             box on
             xlabel('First component')
             ylabel('Second component')
             %Be careful that this order is consistent with the folder list provided at the beginning of the script
             lgd = legend(folders_list{1},folders_list{3},folders_list{5}, [folders_list{1} 'C'],[folders_list{3} 'C'] ,[ folders_list{5} 'C']);
             saveas(gcf,['TNSE_val_mean_ch_old' num2str(channel) '_sorting' alg '.png']);
             saveas(gcf,['TNSE_val_mean_ch_old' num2str(channel) '_sorting' alg '.eps']);
              
             %Plot YOUNG groups
             % Assure that order matches the list provided at the begining of the script
             % Improvement: set those numbers automatically! 
             figure
             hold on
             plot(score(1,4:9),score(2,4:9),'g*')
             plot(score(1,14:19),score(2,14:19),'c*')
             plot(score(1,25:27),score(2,25:27),'m*')
             plot(score(1,34:37),score(2,34:37),'go')
             plot(score(1,42:47),score(2,42:47),'co')
             plot(score(1,51:55),score(2,51:55),'mo')
             lgd = legend(folders_list{2},folders_list{4},folders_list{6} );

             hold off
             box on
             xlabel('First component')
             ylabel('Second component')
             %Be careful that this order is consistent with the folder list provided at the beginning of the script
             lgd = legend(folders_list{2},folders_list{4},folders_list{6}, [folders_list{2} 'C'],[folders_list{4} 'C'],[folders_list{6} 'C']);
             saveas(gcf,['TNSE_val_mean_ch_old' num2str(channel) '_sorting' alg 'perp_' num2str(perplexity_values(hh)) 'rep_' num2str(jj) '.png']);
             saveas(gcf,['TNSE_val_mean_ch_old' num2str(channel) '_sorting' alg 'perp_' num2str(perplexity_values(hh)) 'rep_' num2str(jj) '.eps']);
            
            end
       end
    end
end
