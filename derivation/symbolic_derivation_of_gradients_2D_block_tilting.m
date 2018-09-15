clear;clc;
% symbols
p_WO     = sym('p_WO',[3,1],'real');
q_WO     = sym('q_WO',[4,1],'real');
p_WH     = sym('p_WH',[3,1],'real');

% parameters
p_OHC = sym('p_OHC',[3,1],'real');
p_WTC_all = sym('p_WTC_all',[3, 2],'real');
p_OTC_all = sym('p_OTC_all',[3, 2],'real');

% Hand contact; table contacts
holonomic_constraint = sym('Phi', [3*(1+2), 1], 'real');
% Hand contact
holonomic_constraint(1:3) = p_WH - (quatOnVec(p_OHC, q_WO)+p_WO);
% table contacts
holonomic_constraint(4:6) = quatOnVec(p_OTC_all(:,1), q_WO)+p_WO-p_WTC_all(:,1);
holonomic_constraint(7:9) = quatOnVec(p_OTC_all(:,2), q_WO)+p_WO-p_WTC_all(:,2);

holonomic_constraint = simplify(holonomic_constraint);

save generated/derivation.mat;
disp('step 1 Done');

%% ---------------------------------------------------------------
%           calculate derivatives
% ---------------------------------------------------------------
% load generated/derivation
deriv_q  = @(f) [
        diff(f,'p_WO1'), diff(f,'p_WO2'), diff(f,'p_WO3'), ...
        diff(f,'q_WO1'), diff(f,'q_WO2'), diff(f,'q_WO3'), diff(f, 'q_WO4'), ...
        diff(f,'p_WH1'), diff(f,'p_WH2'), diff(f,'p_WH3')];

Phi_q  = simplify(deriv_q(holonomic_constraint));
disp('step 2 done');

%% ---------------------------------------------------------------
%           write to file
% ---------------------------------------------------------------
matlabFunction(Phi_q, 'File', 'generated/jac_phi_q_2D_block_tilting', 'vars', ...
    {p_WO, q_WO, p_WH, p_OHC, p_WTC_all, p_OTC_all});
save generated/derivation.mat;
disp('step 3 done');