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

%P53-MDM2 model from Elias et al:
%https://hal.inria.fr/hal-00822308/document
%in nucleus
P_P53Nuc = i; N{i} = 'p53 nucleus'; i=i+1;
P_MDM2Nuc = i; N{i} = 'MDM2 nucleus'; i=i+1;
M_MDM2Nuc = i; N{i} = 'MDM2 mRNA nucleus'; i=i+1;
P_P53NucPhos = i; N{i} = 'p53 nucleus phosphorylated'; i=i+1;
P_ATMNucPhos = i; N{i} = 'ATM nucleus phosphorylated'; i=i+1;
P_WIP1Nuc = i; N{i} = 'WIP1 nucleus'; i=i+1;
M_WIP1Nuc = i; N{i} = 'WIP1 mRNA nucleus'; i=i+1;
%in cytoplasm
P_P53Cyto = i; N{i} = 'p53 cytoplasm'; i=i+1;
P_MDM2Cyto = i; N{i} = 'MDM2 cytoplasm'; i=i+1;
M_MDM2Cyto = i; N{i} = 'MDM2 mRNA cytoplasm'; i=i+1;
P_WIP1Cyto = i; N{i} = 'WIP1 cytoplasm'; i=i+1;
M_WIP1Cyto = i; N{i} = 'WIP1 mRNA cytoplasm'; i=i+1;

%Apoptosis module 1
%Stress-specific response of the p53-Mdm2 feedback loop from Hunziker et al:
%https://www.ncbi.nlm.nih.gov/pubmed/20624280
%
P_P53NucNeg = i; N{i} = 'p53 nucleus in negative feedback loop'; i=i+1;
P_MDM2NucNeg = i; N{i} = 'MDM2 nucleus in negative feedback loop'; i=i+1;
M_MDM2NucNeg = i; N{i} = 'MDM2 mRNA nucleus in negative feedback loop'; i=i+1;
P_P53_MDM2_Comp = i; N{i} = 'p53-MDM2 complex'; i=i+1;

%Apoptosis module 2

%Cell cycle arrest module



numEntities = i-1;
