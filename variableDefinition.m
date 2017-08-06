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

%Cell cycle arrest module



numEntities = i-1;
