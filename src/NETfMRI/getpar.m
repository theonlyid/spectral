function [par] = getpar (experimentname)
%% function to get experiment information per monkey
% 20200116 JSM


if strcmp(experimentname, 'B12GF1')
    par.experiment              = 'B12GF1';
    par.folder                  = 'B12.GF1';
    par.groupName               = 'spont';
    par.sessions                = 1:50;
    
elseif strcmp(experimentname, 'C12EX1')
    par.experiment              = 'C12EX1';
    par.folder                  = 'C12.EX1';
    par.groupName               = 'spont';
    par.sessions                = 1:52;
    
elseif strcmp(experimentname, 'H13GA1')
    par.experiment              = 'H13GA1';
    par.folder                  = 'H13.GA1';
    par.groupName               = 'spont';
    par.sessions                = 1:6;
    
elseif strcmp(experimentname, 'H13GV1')
    par.experiment              = 'H13GV1';
    par.folder                  = 'H13.GV1';
    par.groupName               = 'spont';
    par.sessions                = 1:52;
    
elseif strcmp(experimentname, 'K07Ef1')
    par.experiment              = 'K07Ef1';
    par.folder                  = 'K07.Ef1';
    par.groupName               = 'spont';
    par.sessions                = 1:5;
    
elseif strcmp(experimentname, 'K07EH1')
    par.experiment              = 'K07EH1';
    par.folder                  = 'K07.EH1';
    par.groupName               = 'spont';
    par.sessions                = [1:9];
    
elseif strcmp(experimentname, 'K07FT1')
    par.experiment              = 'K07FT1';
    par.folder                  = 'K07.FT1';
    par.groupName               = 'spont';
    par.sessions                = 1:61;
    
else
    error('unkown experiment name! choices are: B12GF1, C12EX1, H13GA1, H13GV1, K07Ef1, K07EH1, K07FT1' )
end

end

