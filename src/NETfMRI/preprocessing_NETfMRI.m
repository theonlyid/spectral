%% Experimental Data Analysis Pipeline - Preprocessing
% JS/CK 14.01.2020
% get, load, convert, and clean data for experiments:
% B12Gf1 | C12EX1 | H13GA1 | H13GV1 | K07EF1 | K07EH1 | K07FT1

% get parameters (par.)
par = getpar('');

% load & convert data
sesdumppar(par.experiment, par.groupName);
sesascan(par.experiment, par.groupName);
sesimgload(par.experiment, par.groupName);
% sesareats(par.experiment, par.sessions); % can only be run after defining rois (mroi).

% clean neural data
sesclnadjevt(par.experiment, par.sessions)
sesgetcln(par.experiment, par.sessions)
sesgetblp(par.experiment, par.sessions)
