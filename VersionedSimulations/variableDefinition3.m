%if using single compartment, single = true, otherwise use single = false
%for multi-compartment. Make sure this is consistent with the vX.m file.
global single; single = true;
i=1;

%prefixes for the entities: P = protein, M = mRNA, O=other. We will probably come up with more of these
%as we add more to the model. We might also add suffixes or something for post translational modifications.

%MODULE: Radiation damage and repair process, modeled without reference to any specific proteins involved in
%double strand break repair, but we may add these in later. For now this just gets us some flexibility in
%modeling the time dynamics of DNA repair. All are marked as 'O' since we are modeling neither proteins nor mRNA
%at this point.

O_RADIATION = i; N{i} = 'Radiation pulse'; i=i+1;
O_BROKEN_ENDS = i; N{i} = 'Broken DNA ends';i=i+1;
O_CAPS = i; N{i} = 'Caps'; i=i+1;
O_CAPPED_ENDS = i; N{i} = 'Capped ends'; i=i+1;
O_CAPPED_ENDS_READY = i; N{i} = 'Capped ends repaired'; i=i+1;
O_FIXED = i; N{i} = 'Fixed DNA ends'; i=i+1;

%Apoptosis module 1

%Apoptosis module 2
P_Bcl2 = i; N{i} = 'Bcl-2'; i=i+1;
P_BclXl = i; N{i} = 'Bcl-Xl'; i=i+1;
P_FasL = i; N{i} = 'FasL'; i=i+1;
P_Bax = i; N{i} = 'Bax'; i=i+1;
P_Apaf1 = i; N{i} = 'Apaf1'; i=i+1;
P_CytC = i; N{i} = 'Cyt c'; i=i+1;
P_Apoptosome = i; N{i} = 'Apoptosome'; i=i+1;
O_Apoptosis = i; N{i} = 'Apoptosis'; i=i+1;

%Cell cycle arrest module
P_p21cip = i; N{i} = 'p21 cip'; i=i+1;
P_ECDK2 = i; N{i} = 'ECDK2'; i=i+1;
O_ARRESTSIGNAL = i; N{i} = 'Arrest signal'; i=i+1;
O_CELLCYCLING = i; N{i} = 'Cell Cycling'; i=i+1;
P_E2F = i; N{i} = 'E2F'; i=i+1;
P_ARF = i; N{i} = 'ARF'; i=i+1;
P_Siah = i; N{i} = 'Siah'; i=i+1;
P_Reprimo = i; N{i} = 'Reprimo'; i=i+1;

%P53-MDM2 model from Elias et al:
%https://hal.inria.fr/hal-00822308/document
%in nucleus
P_P53Nuc = i; N{i} = 'p53 nucleus'; i=i+1;
P_MDM2Nuc = i; N{i} = 'MDM2nuc'; i=i+1;
M_MDM2Nuc = i; N{i} = 'MDM2 mRNAnuc'; i=i+1;
P_P53NucPhos = i; N{i} = 'p53nucPhos'; i=i+1;
P_ATMNucPhos = i; N{i} = 'ATMnucPhos'; i=i+1;
P_WIP1Nuc = i; N{i} = 'WIP1 nuc'; i=i+1;
M_WIP1Nuc = i; N{i} = 'WIP1 mRNA nucleus'; i=i+1;


%in cytoplasm -> make sure these are at end of variableDefinition file
P_P53Cyto = i; N{i} = 'p53 cytoplasm'; i=i+1;
P_MDM2Cyto = i; N{i} = 'MDM2 cytoplasm'; i=i+1;
M_MDM2Cyto = i; N{i} = 'MDM2 mRNA cytoplasm'; i=i+1;
P_WIP1Cyto = i; N{i} = 'WIP1 cytoplasm'; i=i+1;
M_WIP1Cyto = i; N{i} = 'WIP1 mRNA cytoplasm'; i=i+1;
numEntities = i-1;
