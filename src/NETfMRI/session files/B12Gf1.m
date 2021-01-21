% B12GF1 - 27. Feb 17: fMRI+Neurophys (2 Shanks, AIC, Cortex) in 7T
% SESSION:  B12GF1
% EXPDATE:  27. Feb 17
% PROJECT:  NET-fMRI AIC
%
%==========================================================================
%
% NOTE:
%
%   - Physiology, Dev 1
%   - Insula-R, ele #03-Green, Dev 2/1, F2
%   - Insula-L, ele #04-Green, Dev 2/2, F3
%   - Cortex-R, ele #13-Grey,  Dev 3/1, F4
%   - Cortex-L, ele #23-Red, Dev 3/2, F5
%
%   - Insula-R ele #03-Green (F2 amp)
%     Ele          1     2     3     4     5     6     7     8     9    10
%     kOhm         40    130   130   150   160   80    140   50    60   120
%     ADF                            2     1           2                 
%     RecGain                        2     1           2                    (fMRI)
%
%   - Insula-L ele #04-Green (F3 amp)
%     Ele          1     2     3     4     5     6     7     8     9    10
%     kOhm         130   150   100   130   30    30    140   70    10   210
%     ADF          5     5     4     5                 5     2          5
%     RecGain      10    10    6     10                10    2          10  (fMRI)
%
%   - Cortex-R ele #13-Grey (F4 amp)
%     Ele          1     2     3     4     5     6     7     8     9     10
%     kOhm         160   180   150   170   140   170   160   180   150   190
%     ADF          4     4     4     5     4     5                 5
%     RecGain      6     6     6     10    6     10                10        (fMRI)
%
%   - Cortex-L ele #23Red (F5 amp)
%     Ele          1     2     3     4     5     6     7     8     9     10
%     kOhm               170   230   150   210   180   160   160   150   140
%     ADF          7     5     6     5     4     5     6     5     4     5
%     RecGain      30    10    20    10    6     10    20    10    6     10  (fMRI)
%
%   - ADF 14-gradient 
%
%
% AUTHOR: JS/CK, 13.01.2020%
%
%% ========================================================================
%   BASIC INFORMATION
%  ========================================================================

% Raw data directories & meta information
SYSP.DataMri        = '\\wks8\mridata_wks6';
SYSP.DataNeuro      = SYSP.DataMri;
SYSP.dirname        = 'B12.Gf1';
SYSP.date           = '27. Feb 17';

ARGS.StateIDX       = 0;
ARGS.Animal         = 'monkey';

% Common parameters
[ANAP, ROI, GRPP, FLICK, ESTIM, POLAR] = ingetpars('B12GF1',ARGS);

% Processed data directories
SYSP.matdir         = ANAP.project.datadir;
SYSP.DataMatlab     = SYSP.matdir;
    if isfield(ANAP.project,'DataMri')
      SYSP.DataMri      = ANAP.project.DataMri;
    end
    
    if isfield(ANAP.project,'DataNeuro')
      SYSP.DataNeuro    = ANAP.project.DataNeuro;
    end

SYSP.VERSION        = ANAP.SYSP.VERSION; % EACH SESSION GETS, and then we run sesconvert(SesName);
SYSP.VERSION        = 2.0;

%% ========================================================================
%   DISPLAY OF ANATOMY SCANS
%  ========================================================================

% Anatomical parameters used by mview
ANAP.mview.anascale         = [0 12000 1.5];
ANAP.mview.funscale         = [-5 30];
ANAP.mview.alpha            = 0.01;
ANAP.mview.slices           = [];
ANAP.Quality                = -1;   % Percent (all exps good activation)
ANAP.ImgDistort             =  0;   % EPI-Anatomy can't be registered due2distortions

EPICROP  = [1 1 128 128];           % cropping as [x y width height]
EPI2ANA  =  2;

% Anatomy scan information
% Rare scan
ASCAN.rare{1}.info          = 'In-plane Anatomy';
ASCAN.rare{1}.scanreco      = [18 1];
ASCAN.rare{1}.imgcrop       = [(EPICROP(1)-1)*EPI2ANA+1 (EPICROP(2)-1)*EPI2ANA+1 EPICROP(3:4)*EPI2ANA];

% Flash scan 
ASCAN.flash{1}.info          = 'Electrode (Coronal), AIC';
ASCAN.flash{1}.scanreco      = [17 1];
ASCAN.flash{1}.imgcrop       = [];

% Display information
GRPP.ana                                        = {'rare'; 1; 2:2:40}; % inplane anatomy
GRPP.imgcrop                                    = EPICROP;
GRPP.condition                                  = {'normal'};
GRPP.anap.mrhesusatlas2ana.permute              = [];
GRPP.anap.mrhesusatlas2ana.flipdim              = 2;
GRPP.anap.mrhesusatlas2ana.spm_coreg.cost_fun   = 'nmi';
GRPP.anap.mrhesusatlas2ana.use_epi              = 0;
GRPP.anap.mana2brain.use_epi                    = 1; % COREG from session data into the template brain.


%% ========================================================================
%   GROUP INFORMATION
%  ========================================================================

% Channel/electrode information (empty space = channel wasn't working)
GRPP.daqver        = 2.00;                                  % DAQ program version: 2=nl+ym; 1=nl;
GRPP.hardch        = [9 10 12 15:21 22:28 29:38];           % electrode numbers for ADF_CHANNELs 
GRPP.gradch        = 14;
GRPP.namech        = {                               'insR04'  'insR05'            'insR07'                               ...
                       'insL01'  'insL02'  'insL03'  'insL04'                      'insL07'  'insL08'            'insL10' ...
                       'corR01'  'corR02'  'corR03'  'corR04'  'corR05'  'corR06'                      'corR09'           ...
                       'corL01'  'corL02'  'corL03'  'corL04'  'corL05'  'corL06'  'corL07'  'corL08'  'corL09'  'corL10'};

GRPP.recgain       = [                   2     1           2                      ...
                       10    10    6     10                10    2           10   ...
                       6     6     6     10    6     10                10         ...
                       30    10    20    10    6     10    20    10    6     10 ];
                   
GRPP.elekohm       = [ 40    130   130   150   160   80    140   50    60    120  ...
                       130   150   100   130   30    30    140   70    10    210 ...
                       160   180   150   170   140   170   160   180   150   190 ...
                       NaN   170   230   150   210   180   160   160   150   140];
                                      
GRPP.anap.clnpar.METHOD                     = 'pca'; % faster singular values decomposition for pca
GRPP.anap.clnpar.HIGHPASS                   = 1; % Cutoff freq for high pass (in Hz)
GRPP.anap.clnpar.USE_LANSVD                 = 1;    
GRPP.anap.clnpar.PLOT                       = 1; % save spectrum figures before/after cleaning
GRPP.anap.clnpar.DECFRAC                    = 2; % originally in decmain.m, needs to be changed if smaplef from 20k to 15k

GRPP.anap.clnpar.AVR_NOISE                  = 'mean';  % faster singular values decomposition for pca
GRPP.anap.clnpar.NOPCS                      = 32;      % GRPP.anap.clnpar.METHOD      = 'regress';
GRPP.anap.clnpar.NOREM                      = 28;
GRPP.anap.clnpar.PCACOEF                    = 0.25;    % 0.25 standard value. Can be set to 0.15 to potentially improve.
GRPP.anap.clnpar.PCACOEF                    = 0.12;

% Spont group information
GRP.spont                               = GRPP;
GRP.spont.ana                           = {'rare'; 2; [2:2:40]}; % inplane anatomy
% GRP.spont.ana                           = { 'rare' 3 [] };     % morphed anatomy 
% GRP.spont.grproi                        = 'RoiGrp2';           % use for a second ROI map
GRP.spont.exps                          = 1:48; 
GRP.spont.design                        = 'No stim';
GRP.spont.stminfo                       = 'spontaneous with fMRI 10 min';
GRP.spont.label                         = {'spont'};
GRP.spont.refgrp.grpexp                 = 'spont';
GRP.spont.expinfo                       = {'imaging','recording'};
GRP.spont.anap.clnpar.HIGHPASS          = 1;      % Cutoff freq for high pass (in Hz)
GRP.spont.anap.mareats.IEXCLUDE         = {};     % {'brain'};
GRP.spont.anap.mareats.IREMBRAINMEAN    = 0;      % Remove brain's average (phys artifacts)
GRP.spont.anap.mareats.IFILTER          = 1;      % 1=to spatially filter; 0=no filter at all; old 1
GRP.spont.anap.mareats.IFILTER_KSIZE    = 3;      % Kernel size (previously 3)
GRP.spont.anap.mareats.IFILTER_SD       = 0.7;    % Kernel SD (90% of flt in kernel) (previously 1.5)
GRP.spont.anap.mareats.ICUTOFFHIGH      = 0.01;   % remove very slow oscillations
GRP.spont.anap.mareats.ICUTOFF          = 0.05;   % 0.5 is Nyquist; 0.200 is old; 0.050 best result
GRP.spont.anap.mareats.INOTCH           = 0;      % Def: 4; Threshold for resp-art removal
GRP.spont.anap.mareats.ITOSDU           = 0;      % Normalization % Doesn't work without baseline. Geht erst, wenn man events etc. hat.

%% ========================================================================
%   RUN INFORMATION
%  ========================================================================

A = [33:34 37:98];
ind = ones(size(A));
ind(3:4:end) = 0;
A = A(logical(ind));

e = 1;
for N = A
    EXPP(e).physfile = sprintf('B12_Gf1_%03d.adfx',N-30);
    EXPP(e).scanreco = [N 2];
    e = e+1;
end
