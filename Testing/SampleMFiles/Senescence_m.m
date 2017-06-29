% This file works with OCTAVE and is automatically generated with 
% the System Biology Format Converter (http://sbfc.sourceforge.net/)
% from an SBML file.
% To run this file with Matlab you must edit the comments providing
% the definition of the ode solver and the signature for the 
% xdot function.
%
% The conversion system has the following limitations:
%  - You may have to re order some reactions and Assignment Rules definition
%  - Delays are not taken into account
%  - You should change the lsode parameters (start, end, steps) to get better results
%

%
% Model name = DallePezze2014 -  Cellular senescene-induced mitochondrial dysfunction
%
% is http://identifiers.org/biomodels.db/MODEL1506230000
% is http://identifiers.org/biomodels.db/BIOMD0000000582
% isDescribedBy http://identifiers.org/pubmed/25166345
%

function main()
%Initial conditions vector
	x0=zeros(40,1);
	x0(1) = 10.0;
	x0(2) = 10.0;
	x0(3) = 10.0;
	x0(4) = 10.0;
	x0(5) = 10.0;
	x0(6) = 10.0;
	x0(7) = 10.0;
	x0(8) = 10.0;
	x0(9) = 10.0;
	x0(10) = 10.0;
	x0(11) = 10.0;
	x0(12) = 25.0;
	x0(13) = 10.0;
	x0(14) = 10.0;
	x0(15) = 1.0;
	x0(16) = 0.81;
	x0(17) = 10.0;
	x0(18) = 1.0;
	x0(19) = 0.0;
	x0(20) = 25.0;
	x0(21) = 12.12;
	x0(22) = 0.0;
	x0(23) = 0.0;
	x0(24) = 1.0;
	x0(25) = 1.0;
	x0(26) = 1.0;
	x0(27) = 1.0;
	x0(28) = 10.0;
	x0(29) = 10.0;
	x0(30) = 10.0;
	x0(31) = 10.0;
	x0(32) = 10.0;
	x0(33) = 10.0;
	x0(34) = 20.0;
	x0(35) = 1.0;
	x0(36) = 12.12;
	x0(37) = 10.0;
	x0(38) = 10.0;
	x0(39) = 10.0;
	x0(40) = 0.81;


% Depending on whether you are using Octave or Matlab,
% you should comment / uncomment one of the following blocks.
% This should also be done for the definition of the function f below.
% Start Matlab code
	tspan=[0:0.01:100];
	opts = odeset('AbsTol',1e-3);
	[t,x]=ode23tb(@f,tspan,x0,opts);
% End Matlab code

% Start Octave code
% 	t=linspace(0,100,100);
% 	x=lsode('f',x0,t);
% End Octave code


	plot(t,x);
end



% Depending on whether you are using Octave or Matlab,
% you should comment / uncomment one of the following blocks.
% This should also be done for the definition of the function f below.
% Start Matlab code
function xdot=f(t,x)
% End Matlab code

% Start Octave code
% function xdot=f(x,t)
% End Octave code

time = linspace(1,20,100)
% Compartment: id = Cell, name = Cell, constant
	compartment_Cell=1.0;
% Parameter:   id =  Akt_S473_phos_by_insulin, name = Akt_S473_phos_by_insulin
	global_par_Akt_S473_phos_by_insulin=0.588783148144923;
% Parameter:   id =  Akt_pS473_dephos_by_mTORC1_pS2448, name = Akt_pS473_dephos_by_mTORC1_pS2448
	global_par_Akt_pS473_dephos_by_mTORC1_pS2448=0.114598191621279;
% Parameter:   id =  AMPK_T172_phos, name = AMPK_T172_phos
	global_par_AMPK_T172_phos=0.355183987378767;
% Parameter:   id =  AMPK_pT172_dephos_by_Mito_membr_pot_new, name = AMPK_pT172_dephos_by_Mito_membr_pot_new
	global_par_AMPK_pT172_dephos_by_Mito_membr_pot_new=0.117744691539618;
% Parameter:   id =  AMPK_pT172_dephos_by_Mito_membr_pot_old, name = AMPK_pT172_dephos_by_Mito_membr_pot_old
	global_par_AMPK_pT172_dephos_by_Mito_membr_pot_old=1.00000000000003E-6;
% Parameter:   id =  mTORC1_S2448_phos_by_AA, name = mTORC1_S2448_phos_by_AA
	global_par_mTORC1_S2448_phos_by_AA=1.00008999860285E-6;
% Parameter:   id =  mTORC1_S2448_phos_by_AA_n_Akt_pS473, name = mTORC1_S2448_phos_by_AA_n_Akt_pS473
	global_par_mTORC1_S2448_phos_by_AA_n_Akt_pS473=162.471039450073;
% Parameter:   id =  mTORC1_pS2448_dephos_by_AMPK_pT172, name = mTORC1_pS2448_dephos_by_AMPK_pT172
	global_par_mTORC1_pS2448_dephos_by_AMPK_pT172=191.297262771509;
% Parameter:   id =  mitophagy_activ_by_FoxO3a_n_AMPK_pT172, name = mitophagy_activ_by_FoxO3a_n_AMPK_pT172
	global_par_mitophagy_activ_by_FoxO3a_n_AMPK_pT172=1319.84219165251;
% Parameter:   id =  mitophagy_inactiv_by_mTORC1_pS2448, name = mitophagy_inactiv_by_mTORC1_pS2448
	global_par_mitophagy_inactiv_by_mTORC1_pS2448=645.999307230137;
% Parameter:   id =  FoxO3a_phos_by_Akt_pS473, name = FoxO3a_phos_by_Akt_pS473
	global_par_FoxO3a_phos_by_Akt_pS473=6.83511123229576;
% Parameter:   id =  FoxO3a_phos_by_JNK_pT183, name = FoxO3a_phos_by_JNK_pT183
	global_par_FoxO3a_phos_by_JNK_pT183=0.112877630496044;
% Parameter:   id =  FoxO3a_pS253_degrad, name = FoxO3a_pS253_degrad
	global_par_FoxO3a_pS253_degrad=39.4068609318082;
% Parameter:   id =  FoxO3a_synthesis, name = FoxO3a_synthesis
	global_par_FoxO3a_synthesis=407.307409980937;
% Parameter:   id =  CDKN1A_transcr_by_FoxO3a_n_DNA_damage, name = CDKN1A_transcr_by_FoxO3a_n_DNA_damage
	global_par_CDKN1A_transcr_by_FoxO3a_n_DNA_damage=0.0852182335681166;
% Parameter:   id =  CDKN1A_inactiv_by_Akt_pS473, name = CDKN1A_inactiv_by_Akt_pS473
	global_par_CDKN1A_inactiv_by_Akt_pS473=0.0667971061916905;
% Parameter:   id =  CDKN1B_transcr_by_FoxO3a_n_DNA_damage, name = CDKN1B_transcr_by_FoxO3a_n_DNA_damage
	global_par_CDKN1B_transcr_by_FoxO3a_n_DNA_damage=0.0920526565951487;
% Parameter:   id =  CDKN1B_inactiv_by_Akt_pS473, name = CDKN1B_inactiv_by_Akt_pS473
	global_par_CDKN1B_inactiv_by_Akt_pS473=0.0596841598127919;
% Parameter:   id =  DNA_damaged_by_irradiation, name = DNA_damaged_by_irradiation
	global_par_DNA_damaged_by_irradiation=9237.72311545872;
% Parameter:   id =  DNA_repair, name = DNA_repair
	global_par_DNA_repair=0.325724769122274;
% Parameter:   id =  DNA_damaged_by_ROS, name = DNA_damaged_by_ROS
	global_par_DNA_damaged_by_ROS=0.118873655169353;
% Parameter:   id =  ROS_prod_by_Mito_membr_pot_new, name = ROS_prod_by_Mito_membr_pot_new
	global_par_ROS_prod_by_Mito_membr_pot_new=4.55464788075885;
% Parameter:   id =  ROS_prod_by_Mito_membr_pot_old, name = ROS_prod_by_Mito_membr_pot_old
	global_par_ROS_prod_by_Mito_membr_pot_old=772.829490967078;
% Parameter:   id =  ROS_turnover, name = ROS_turnover
	global_par_ROS_turnover=3.23082321168464;
% Parameter:   id =  JNK_activ_by_ROS, name = JNK_activ_by_ROS
	global_par_JNK_activ_by_ROS=0.00502329152478409;
% Parameter:   id =  JNK_pT183_inactiv, name = JNK_pT183_inactiv
	global_par_JNK_pT183_inactiv=0.0718429173444438;
% Parameter:   id =  IKKbeta_activ_by_ROS, name = IKKbeta_activ_by_ROS
	global_par_IKKbeta_activ_by_ROS=1.0;
% Parameter:   id =  IKKbeta_inactiv, name = IKKbeta_inactiv
	global_par_IKKbeta_inactiv=1.0;
% Parameter:   id =  mTORC1_S2448_phos_by_AA_n_IKKbeta, name = mTORC1_S2448_phos_by_AA_n_IKKbeta
	global_par_mTORC1_S2448_phos_by_AA_n_IKKbeta=1.00008996727694E-5;
% Parameter:   id =  sen_ass_beta_gal_inc_by_ROS, name = sen_ass_beta_gal_inc_by_ROS
	global_par_sen_ass_beta_gal_inc_by_ROS=0.0701139988718817;
% Parameter:   id =  sen_ass_beta_gal_inc_by_Mitophagy, name = sen_ass_beta_gal_inc_by_Mitophagy
	global_par_sen_ass_beta_gal_inc_by_Mitophagy=1.00000000000011E-6;
% Parameter:   id =  sen_ass_beta_gal_dec, name = sen_ass_beta_gal_dec
	global_par_sen_ass_beta_gal_dec=0.154821166783837;
% Parameter:   id =  mito_biogenesis_by_mTORC1_pS2448, name = mito_biogenesis_by_mTORC1_pS2448
	global_par_mito_biogenesis_by_mTORC1_pS2448=0.0133620123598202;
% Parameter:   id =  mito_biogenesis_by_AMPK_pT172, name = mito_biogenesis_by_AMPK_pT172
	global_par_mito_biogenesis_by_AMPK_pT172=5.8915457309741E-5;
% Parameter:   id =  mitophagy_new, name = mitophagy_new
	global_par_mitophagy_new=0.22465992989378;
% Parameter:   id =  mitophagy_old, name = mitophagy_old
	global_par_mitophagy_old=0.00122607614891116;
% Parameter:   id =  mito_dysfunction, name = mito_dysfunction
	global_par_mito_dysfunction=0.0270695257507146;
% Parameter:   id =  mito_membr_pot_new_inc, name = mito_membr_pot_new_inc
	global_par_mito_membr_pot_new_inc=9882.02736076158;
% Parameter:   id =  mito_membr_pot_old_inc, name = mito_membr_pot_old_inc
	global_par_mito_membr_pot_old_inc=0.00586017882122243;
% Parameter:   id =  mito_membr_pot_new_dec, name = mito_membr_pot_new_dec
	global_par_mito_membr_pot_new_dec=1094.58423149719;
% Parameter:   id =  mito_membr_pot_old_dec, name = mito_membr_pot_old_dec
	global_par_mito_membr_pot_old_dec=0.954903499913184;
% Parameter:   id =  scale_Akt_pS473_obs, name = scale_Akt_pS473_obs
	global_par_scale_Akt_pS473_obs=1.0;
% Parameter:   id =  scale_FoxO3a_pS253_obs, name = scale_FoxO3a_pS253_obs
	global_par_scale_FoxO3a_pS253_obs=1.0;
% Parameter:   id =  scale_FoxO3a_total_obs, name = scale_FoxO3a_total_obs
	global_par_scale_FoxO3a_total_obs=1.0;
% Parameter:   id =  scale_AMPK_pT172_obs, name = scale_AMPK_pT172_obs
	global_par_scale_AMPK_pT172_obs=1.0;
% Parameter:   id =  scale_mTOR_pS2448_obs, name = scale_mTOR_pS2448_obs
	global_par_scale_mTOR_pS2448_obs=1.0;
% Parameter:   id =  scale_Mitophagy_obs, name = scale_Mitophagy_obs
	global_par_scale_Mitophagy_obs=1.0;
% Parameter:   id =  scale_Mito_Mass_obs, name = scale_Mito_Mass_obs
	global_par_scale_Mito_Mass_obs=1.0;
% Parameter:   id =  scale_Mito_Membr_Pot_obs, name = scale_Mito_Membr_Pot_obs
	global_par_scale_Mito_Membr_Pot_obs=1.0;
% Parameter:   id =  scale_CDKN1A_obs, name = scale_CDKN1A_obs
	global_par_scale_CDKN1A_obs=1.0;
% Parameter:   id =  scale_CDKN1B_obs, name = scale_CDKN1B_obs
	global_par_scale_CDKN1B_obs=1.0;
% Parameter:   id =  scale_ROS_obs, name = scale_ROS_obs
	global_par_scale_ROS_obs=1.0;
% Parameter:   id =  scale_DNA_damage_gammaH2AX_obs, name = scale_DNA_damage_gammaH2AX_obs
	global_par_scale_DNA_damage_gammaH2AX_obs=1.0;
% Parameter:   id =  scale_JNK_pT183_obs, name = scale_JNK_pT183_obs
	global_par_scale_JNK_pT183_obs=1.0;
% Parameter:   id =  scale_SA_beta_gal_obs, name = scale_SA_beta_gal_obs
	global_par_scale_SA_beta_gal_obs=1.0;
% assignmentRule: variable = DNA_damage_gammaH2AX_obs
	x(27)=global_par_scale_DNA_damage_gammaH2AX_obs*x(15);
% assignmentRule: variable = Insulin
	x(24)=piecewise(1, time < (-1), piecewise(1, time < 0, 1));
% assignmentRule: variable = Amino_Acids
	x(25)=piecewise(1, time < (-1), piecewise(1, time < 0, 1));
% assignmentRule: variable = Irradiation
	x(26)=piecewise(0, time < (-1), piecewise(0, time < 0, piecewise(1, time < 0.003472, 0)));
% assignmentRule: variable = Akt_pS473_obs
	x(28)=global_par_scale_Akt_pS473_obs*x(2);
% assignmentRule: variable = SA_beta_gal_obs
	x(40)=global_par_scale_SA_beta_gal_obs*x(16);
% assignmentRule: variable = JNK_pT183_obs
	x(39)=global_par_scale_JNK_pT183_obs*x(13);
% assignmentRule: variable = ROS_obs
	x(38)=global_par_scale_ROS_obs*x(14);
% assignmentRule: variable = FoxO3a_total_obs
	x(34)=global_par_scale_FoxO3a_total_obs*(x(8)+x(9));
% assignmentRule: variable = Mitophagy_obs
	x(37)=global_par_scale_Mitophagy_obs*x(7);
% assignmentRule: variable = Mito_Membr_Pot_obs
	x(36)=global_par_scale_Mito_Membr_Pot_obs*(x(21)+x(22));
% assignmentRule: variable = CDKN1B_obs
	x(32)=global_par_scale_CDKN1B_obs*x(11);
% assignmentRule: variable = CDKN1A_obs
	x(31)=global_par_scale_CDKN1A_obs*x(10);
% assignmentRule: variable = Mito_Mass_obs
	x(35)=global_par_scale_Mito_Mass_obs*(x(18)+x(19));
% assignmentRule: variable = AMPK_pT172_obs
	x(30)=global_par_scale_AMPK_pT172_obs*x(4);
% assignmentRule: variable = FoxO3a_pS253_obs
	x(33)=global_par_scale_FoxO3a_pS253_obs*x(9);
% assignmentRule: variable = mTOR_pS2448_obs
	x(29)=global_par_scale_mTOR_pS2448_obs*x(6);


    
% Reaction: id = reaction_1, name = reaction_1
	reaction_reaction_1=compartment_Cell*function_4_reaction_1_1(x(1), global_par_Akt_S473_phos_by_insulin, x(24));

% Reaction: id = reaction_2, name = reaction_2
	reaction_reaction_2=compartment_Cell*function_4_reaction_2_1(x(2), global_par_Akt_pS473_dephos_by_mTORC1_pS2448, x(6));

% Reaction: id = reaction_3, name = reaction_3
	reaction_reaction_3=compartment_Cell*global_par_AMPK_T172_phos*x(3);

% Reaction: id = reaction_4, name = reaction_4
	reaction_reaction_4=compartment_Cell*function_4_reaction_4_1(x(4), global_par_AMPK_pT172_dephos_by_Mito_membr_pot_new, x(21));

% Reaction: id = reaction_5, name = reaction_5
	reaction_reaction_5=compartment_Cell*function_4_reaction_5_1(x(4), global_par_AMPK_pT172_dephos_by_Mito_membr_pot_old, x(22));

% Reaction: id = reaction_6, name = reaction_6
	reaction_reaction_6=compartment_Cell*function_4_reaction_6_1(x(25), x(5), global_par_mTORC1_S2448_phos_by_AA);

% Reaction: id = reaction_7, name = reaction_7
	reaction_reaction_7=compartment_Cell*function_4_reaction_7_1(x(2), x(25), x(5), global_par_mTORC1_S2448_phos_by_AA_n_Akt_pS473);

% Reaction: id = reaction_8, name = reaction_8
	reaction_reaction_8=compartment_Cell*function_4_reaction_8_1(x(4), x(6), global_par_mTORC1_pS2448_dephos_by_AMPK_pT172);

% Reaction: id = reaction_9, name = reaction_9
	reaction_reaction_9=compartment_Cell*function_4_reaction_9_1(x(4), x(8), global_par_mitophagy_activ_by_FoxO3a_n_AMPK_pT172);

% Reaction: id = reaction_10, name = reaction_10
	reaction_reaction_10=compartment_Cell*function_4_reaction_10_1(x(7), x(6), global_par_mitophagy_inactiv_by_mTORC1_pS2448);

% Reaction: id = reaction_11, name = reaction_11
	reaction_reaction_11=compartment_Cell*function_4_reaction_11_1(x(2), x(8), global_par_FoxO3a_phos_by_Akt_pS473);

% Reaction: id = reaction_12, name = reaction_12
	reaction_reaction_12=compartment_Cell*function_4_reaction_12_1(x(9), global_par_FoxO3a_phos_by_JNK_pT183, x(13));

% Reaction: id = reaction_13, name = reaction_13
	reaction_reaction_13=compartment_Cell*global_par_FoxO3a_pS253_degrad*x(9);

% Reaction: id = reaction_14, name = reaction_14
    reaction_reaction_14=compartment_Cell*function_2(global_par_FoxO3a_synthesis)
    
% Reaction: id = reaction_15, name = reaction_15
	reaction_reaction_15=compartment_Cell*function_4_reaction_15_1(global_par_CDKN1A_transcr_by_FoxO3a_n_DNA_damage, x(15), x(8));

% Reaction: id = reaction_16, name = reaction_16
	reaction_reaction_16=compartment_Cell*function_4_reaction_16_1(x(2), x(10), global_par_CDKN1A_inactiv_by_Akt_pS473);

% Reaction: id = reaction_17, name = reaction_17
	reaction_reaction_17=compartment_Cell*function_4_reaction_17_1(global_par_CDKN1B_transcr_by_FoxO3a_n_DNA_damage, x(15), x(8));

% Reaction: id = reaction_18, name = reaction_18
	reaction_reaction_18=compartment_Cell*function_4_reaction_18_1(x(2), x(11), global_par_CDKN1B_inactiv_by_Akt_pS473);

% Reaction: id = reaction_19, name = reaction_19
	reaction_reaction_19=compartment_Cell*function_4_reaction_19_1(global_par_DNA_damaged_by_irradiation, x(26));

% Reaction: id = reaction_20, name = reaction_20
	reaction_reaction_20=compartment_Cell*function_4_reaction_20_1(global_par_DNA_damaged_by_ROS, x(14));

% Reaction: id = reaction_21, name = reaction_21
	reaction_reaction_21=compartment_Cell*global_par_DNA_repair*x(15);

% Reaction: id = reaction_22, name = reaction_22
	reaction_reaction_22=compartment_Cell*function_4_reaction_22_1(x(21), global_par_ROS_prod_by_Mito_membr_pot_new);

% Reaction: id = reaction_23, name = reaction_23
	reaction_reaction_23=compartment_Cell*function_4_reaction_23_1(x(22), global_par_ROS_prod_by_Mito_membr_pot_old);

% Reaction: id = reaction_24, name = reaction_24
	reaction_reaction_24=compartment_Cell*global_par_ROS_turnover*x(14);

% Reaction: id = reaction_25, name = reaction_25
	reaction_reaction_25=compartment_Cell*function_4_reaction_25_1(x(12), global_par_JNK_activ_by_ROS, x(14));

% Reaction: id = reaction_26, name = reaction_26
	reaction_reaction_26=compartment_Cell*global_par_JNK_pT183_inactiv*x(13);

% Reaction: id = reaction_27, name = reaction_27
	reaction_reaction_27=compartment_Cell*function_4_reaction_27_1(x(14), global_par_sen_ass_beta_gal_inc_by_ROS);

% Reaction: id = reaction_28, name = reaction_28
	reaction_reaction_28=compartment_Cell*function_4_reaction_28_1(x(7), global_par_sen_ass_beta_gal_inc_by_Mitophagy);

% Reaction: id = reaction_29, name = reaction_29
	reaction_reaction_29=compartment_Cell*global_par_sen_ass_beta_gal_dec*x(16);

% Reaction: id = reaction_30, name = reaction_30
	reaction_reaction_30=compartment_Cell*function_4_reaction_30_1(x(20), x(6), global_par_mito_biogenesis_by_mTORC1_pS2448);

% Reaction: id = reaction_31, name = reaction_31
	reaction_reaction_31=compartment_Cell*function_4_reaction_31_1(x(20), x(6), global_par_mito_biogenesis_by_AMPK_pT172);

% Reaction: id = reaction_32, name = reaction_32
	reaction_reaction_32=compartment_Cell*function_4_reaction_32_1(x(18), x(7), global_par_mitophagy_new);

% Reaction: id = reaction_33, name = reaction_33
	reaction_reaction_33=compartment_Cell*function_4_reaction_33_1(x(19), x(7), global_par_mitophagy_old);

% Reaction: id = reaction_34, name = reaction_34
	reaction_reaction_34=compartment_Cell*function_4_reaction_34_1(x(10), x(18), global_par_mito_dysfunction);

% Reaction: id = reaction_35, name = reaction_35
	reaction_reaction_35=compartment_Cell*function_4_reaction_35_1(x(18), global_par_mito_membr_pot_new_inc);

% Reaction: id = reaction_36, name = reaction_36
	reaction_reaction_36=compartment_Cell*function_4_reaction_36_1(x(19), global_par_mito_membr_pot_old_inc);

% Reaction: id = reaction_37, name = reaction_37
	reaction_reaction_37=compartment_Cell*global_par_mito_membr_pot_new_dec*x(21);

% Reaction: id = reaction_38, name = reaction_38
	reaction_reaction_38=compartment_Cell*global_par_mito_membr_pot_old_dec*x(22);

% Reaction: id = reaction_39, name = reaction_39
	reaction_reaction_39=compartment_Cell*function_4_reaction_39_1(global_par_IKKbeta_activ_by_ROS, x(14));

% Reaction: id = reaction_40, name = reaction_40
	reaction_reaction_40=compartment_Cell*global_par_IKKbeta_inactiv*x(17);

% Reaction: id = reaction_41, name = reaction_41
	reaction_reaction_41=compartment_Cell*function_4_reaction_41_1(x(25), x(17), x(5), global_par_mTORC1_S2448_phos_by_AA_n_IKKbeta);

	xdot=zeros(40,1);
	
% Species:   id = Akt, name = Akt, affected by kineticLaw
	xdot(1) = (1/(compartment_Cell))*((-1.0 * reaction_reaction_1) + ( 1.0 * reaction_reaction_2));
	
% Species:   id = Akt_pS473, name = Akt_pS473, affected by kineticLaw
	xdot(2) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_1) + (-1.0 * reaction_reaction_2));
	
% Species:   id = AMPK, name = AMPK, affected by kineticLaw
	xdot(3) = (1/(compartment_Cell))*((-1.0 * reaction_reaction_3) + ( 1.0 * reaction_reaction_4) + ( 1.0 * reaction_reaction_5));
	
% Species:   id = AMPK_pT172, name = AMPK_pT172, affected by kineticLaw
	xdot(4) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_3) + (-1.0 * reaction_reaction_4) + (-1.0 * reaction_reaction_5));
	
% Species:   id = mTORC1, name = mTORC1, affected by kineticLaw
	xdot(5) = (1/(compartment_Cell))*((-1.0 * reaction_reaction_6) + (-1.0 * reaction_reaction_7) + ( 1.0 * reaction_reaction_8) + (-1.0 * reaction_reaction_41));
	
% Species:   id = mTORC1_pS2448, name = mTORC1_pS2448, affected by kineticLaw
	xdot(6) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_6) + ( 1.0 * reaction_reaction_7) + (-1.0 * reaction_reaction_8) + ( 1.0 * reaction_reaction_41));
	
% Species:   id = Mitophagy, name = Mitophagy, affected by kineticLaw
	xdot(7) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_9) + (-1.0 * reaction_reaction_10));
	
% Species:   id = FoxO3a, name = FoxO3a, affected by kineticLaw
	xdot(8) = (1/(compartment_Cell))*((-1.0 * reaction_reaction_11) + ( 1.0 * reaction_reaction_12) + ( 1.0 * reaction_reaction_14));
	
% Species:   id = FoxO3a_pS253, name = FoxO3a_pS253, affected by kineticLaw
	xdot(9) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_11) + (-1.0 * reaction_reaction_12) + (-1.0 * reaction_reaction_13));
	
% Species:   id = CDKN1A, name = CDKN1A, affected by kineticLaw
	xdot(10) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_15) + (-1.0 * reaction_reaction_16));
	
% Species:   id = CDKN1B, name = CDKN1B, affected by kineticLaw
	xdot(11) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_17) + (-1.0 * reaction_reaction_18));
	
% Species:   id = JNK, name = JNK, affected by kineticLaw
	xdot(12) = (1/(compartment_Cell))*((-1.0 * reaction_reaction_25) + ( 1.0 * reaction_reaction_26));
	
% Species:   id = JNK_pT183, name = JNK_pT183, affected by kineticLaw
	xdot(13) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_25) + (-1.0 * reaction_reaction_26));
	
% Species:   id = ROS, name = ROS, affected by kineticLaw
	xdot(14) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_22) + ( 1.0 * reaction_reaction_23) + (-1.0 * reaction_reaction_24));
	
% Species:   id = DNA_damage, name = DNA_damage, affected by kineticLaw
	xdot(15) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_19) + ( 1.0 * reaction_reaction_20) + (-1.0 * reaction_reaction_21));
	
% Species:   id = SA_beta_gal, name = SA_beta_gal, affected by kineticLaw
	xdot(16) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_27) + ( 1.0 * reaction_reaction_28) + (-1.0 * reaction_reaction_29));
	
% Species:   id = IKKbeta, name = IKKbeta, affected by kineticLaw
	xdot(17) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_39) + (-1.0 * reaction_reaction_40));
	
% Species:   id = Mito_mass_new, name = Mito_mass_new, affected by kineticLaw
	xdot(18) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_30) + ( 1.0 * reaction_reaction_31) + (-1.0 * reaction_reaction_32) + (-1.0 * reaction_reaction_34));
	
% Species:   id = Mito_mass_old, name = Mito_mass_old, affected by kineticLaw
	xdot(19) = (1/(compartment_Cell))*((-1.0 * reaction_reaction_33) + ( 1.0 * reaction_reaction_34));
	
% Species:   id = Mito_mass_turnover, name = Mito_mass_turnover, affected by kineticLaw
	xdot(20) = (1/(compartment_Cell))*((-1.0 * reaction_reaction_30) + (-1.0 * reaction_reaction_31) + ( 1.0 * reaction_reaction_32) + ( 1.0 * reaction_reaction_33));
	
% Species:   id = Mito_membr_pot_new, name = Mito_membr_pot_new, affected by kineticLaw
	xdot(21) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_35) + (-1.0 * reaction_reaction_37));
	
% Species:   id = Mito_membr_pot_old, name = Mito_membr_pot_old, affected by kineticLaw
	xdot(22) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_36) + (-1.0 * reaction_reaction_38));
	
% Species:   id = Nil, name = Nil, affected by kineticLaw
	xdot(23) = (1/(compartment_Cell))*(( 1.0 * reaction_reaction_10) + ( 1.0 * reaction_reaction_13) + ( 1.0 * reaction_reaction_16) + ( 1.0 * reaction_reaction_18) + ( 1.0 * reaction_reaction_21) + ( 1.0 * reaction_reaction_24) + ( 1.0 * reaction_reaction_37) + ( 1.0 * reaction_reaction_38) + ( 1.0 * reaction_reaction_40));
	
% Species:   id = Insulin, name = Insulin, involved in a rule 	xdot(24) = x(24);
	
% Species:   id = Amino_Acids, name = Amino_Acids, involved in a rule 	xdot(25) = x(25);
	
% Species:   id = Irradiation, name = Irradiation, involved in a rule 	xdot(26) = x(26);
	
% Species:   id = DNA_damage_gammaH2AX_obs, name = DNA_damage_gammaH2AX_obs, involved in a rule 	xdot(27) = x(27);
	
% Species:   id = Akt_pS473_obs, name = Akt_pS473_obs, involved in a rule 	xdot(28) = x(28);
	
% Species:   id = mTOR_pS2448_obs, name = mTOR_pS2448_obs, involved in a rule 	xdot(29) = x(29);
	
% Species:   id = AMPK_pT172_obs, name = AMPK_pT172_obs, involved in a rule 	xdot(30) = x(30);
	
% Species:   id = CDKN1A_obs, name = CDKN1A_obs, involved in a rule 	xdot(31) = x(31);
	
% Species:   id = CDKN1B_obs, name = CDKN1B_obs, involved in a rule 	xdot(32) = x(32);
	
% Species:   id = FoxO3a_pS253_obs, name = FoxO3a_pS253_obs, involved in a rule 	xdot(33) = x(33);
	
% Species:   id = FoxO3a_total_obs, name = FoxO3a_total_obs, involved in a rule 	xdot(34) = x(34);
	
% Species:   id = Mito_Mass_obs, name = Mito_Mass_obs, involved in a rule 	xdot(35) = x(35);
	
% Species:   id = Mito_Membr_Pot_obs, name = Mito_Membr_Pot_obs, involved in a rule 	xdot(36) = x(36);
	
% Species:   id = Mitophagy_obs, name = Mitophagy_obs, involved in a rule 	xdot(37) = x(37);
	
% Species:   id = ROS_obs, name = ROS_obs, involved in a rule 	xdot(38) = x(38);
	
% Species:   id = JNK_pT183_obs, name = JNK_pT183_obs, involved in a rule 	xdot(39) = x(39);
	
% Species:   id = SA_beta_gal_obs, name = SA_beta_gal_obs, involved in a rule 	xdot(40) = x(40);
end

function z=function_2(v), z=(v);end

function z=function_4_reaction_1_1(Akt,Akt_S473_phos_by_insulin,Insulin), z=(Akt_S473_phos_by_insulin*Akt*Insulin);end

function z=function_4_reaction_2_1(Akt_pS473,Akt_pS473_dephos_by_mTORC1_pS2448,mTORC1_pS2448), z=(Akt_pS473_dephos_by_mTORC1_pS2448*Akt_pS473*mTORC1_pS2448);end

function z=function_4_reaction_4_1(AMPK_pT172,AMPK_pT172_dephos_by_Mito_membr_pot_new,Mito_membr_pot_new), z=(AMPK_pT172_dephos_by_Mito_membr_pot_new*AMPK_pT172*Mito_membr_pot_new);end

function z=function_4_reaction_5_1(AMPK_pT172,AMPK_pT172_dephos_by_Mito_membr_pot_old,Mito_membr_pot_old), z=(AMPK_pT172_dephos_by_Mito_membr_pot_old*AMPK_pT172*Mito_membr_pot_old);end

function z=function_4_reaction_6_1(Amino_Acids,mTORC1,mTORC1_S2448_phos_by_AA), z=(mTORC1_S2448_phos_by_AA*mTORC1*Amino_Acids);end

function z=function_4_reaction_7_1(Akt_pS473,Amino_Acids,mTORC1,mTORC1_S2448_phos_by_AA_n_Akt_pS473), z=(mTORC1_S2448_phos_by_AA_n_Akt_pS473*mTORC1*Amino_Acids*Akt_pS473);end

function z=function_4_reaction_8_1(AMPK_pT172,mTORC1_pS2448,mTORC1_pS2448_dephos_by_AMPK_pT172), z=(mTORC1_pS2448_dephos_by_AMPK_pT172*mTORC1_pS2448*AMPK_pT172);end

function z=function_4_reaction_9_1(AMPK_pT172,FoxO3a,mitophagy_activ_by_FoxO3a_n_AMPK_pT172), z=(mitophagy_activ_by_FoxO3a_n_AMPK_pT172*FoxO3a*AMPK_pT172);end

function z=function_4_reaction_10_1(Mitophagy,mTORC1_pS2448,mitophagy_inactiv_by_mTORC1_pS2448), z=(mitophagy_inactiv_by_mTORC1_pS2448*Mitophagy*mTORC1_pS2448);end

function z=function_4_reaction_11_1(Akt_pS473,FoxO3a,FoxO3a_phos_by_Akt_pS473), z=(FoxO3a_phos_by_Akt_pS473*FoxO3a*Akt_pS473);end

function z=function_4_reaction_12_1(FoxO3a_pS253,FoxO3a_phos_by_JNK_pT183,JNK_pT183), z=(FoxO3a_phos_by_JNK_pT183*FoxO3a_pS253*JNK_pT183);end

function z=function_4_reaction_15_1(CDKN1A_transcr_by_FoxO3a_n_DNA_damage,DNA_damage,FoxO3a), z=(CDKN1A_transcr_by_FoxO3a_n_DNA_damage*DNA_damage*FoxO3a);end

function z=function_4_reaction_16_1(Akt_pS473,CDKN1A,CDKN1A_inactiv_by_Akt_pS473), z=(CDKN1A_inactiv_by_Akt_pS473*CDKN1A*Akt_pS473);end

function z=function_4_reaction_17_1(CDKN1B_transcr_by_FoxO3a_n_DNA_damage,DNA_damage,FoxO3a), z=(CDKN1B_transcr_by_FoxO3a_n_DNA_damage*DNA_damage*FoxO3a);end

function z=function_4_reaction_18_1(Akt_pS473,CDKN1B,CDKN1B_inactiv_by_Akt_pS473), z=(CDKN1B_inactiv_by_Akt_pS473*CDKN1B*Akt_pS473);end

function z=function_4_reaction_19_1(DNA_damaged_by_irradiation,Irradiation), z=(DNA_damaged_by_irradiation*Irradiation);end

function z=function_4_reaction_20_1(DNA_damaged_by_ROS,ROS), z=(DNA_damaged_by_ROS*ROS);end

function z=function_4_reaction_22_1(Mito_membr_pot_new,ROS_prod_by_Mito_membr_pot_new), z=(ROS_prod_by_Mito_membr_pot_new*Mito_membr_pot_new);end

function z=function_4_reaction_23_1(Mito_membr_pot_old,ROS_prod_by_Mito_membr_pot_old), z=(ROS_prod_by_Mito_membr_pot_old*Mito_membr_pot_old);end

function z=function_4_reaction_25_1(JNK,JNK_activ_by_ROS,ROS), z=(JNK_activ_by_ROS*JNK*ROS);end

function z=function_4_reaction_27_1(ROS,sen_ass_beta_gal_inc_by_ROS), z=(sen_ass_beta_gal_inc_by_ROS*ROS);end

function z=function_4_reaction_28_1(Mitophagy,sen_ass_beta_gal_inc_by_Mitophagy), z=(sen_ass_beta_gal_inc_by_Mitophagy*Mitophagy);end

function z=function_4_reaction_30_1(Mito_mass_turnover,mTORC1_pS2448,mito_biogenesis_by_mTORC1_pS2448), z=(mito_biogenesis_by_mTORC1_pS2448*Mito_mass_turnover*mTORC1_pS2448);end

function z=function_4_reaction_31_1(Mito_mass_turnover,mTORC1_pS2448,mito_biogenesis_by_AMPK_pT172), z=(mito_biogenesis_by_AMPK_pT172*Mito_mass_turnover*mTORC1_pS2448);end

function z=function_4_reaction_32_1(Mito_mass_new,Mitophagy,mitophagy_new), z=(mitophagy_new*Mito_mass_new*Mitophagy);end

function z=function_4_reaction_33_1(Mito_mass_old,Mitophagy,mitophagy_old), z=(mitophagy_old*Mito_mass_old*Mitophagy);end

function z=function_4_reaction_34_1(CDKN1A,Mito_mass_new,mito_dysfunction), z=(mito_dysfunction*Mito_mass_new*CDKN1A);end

function z=function_4_reaction_35_1(Mito_mass_new,mito_membr_pot_new_inc), z=(mito_membr_pot_new_inc*Mito_mass_new);end

function z=function_4_reaction_36_1(Mito_mass_old,mito_membr_pot_old_inc), z=(mito_membr_pot_old_inc*Mito_mass_old);end

function z=function_4_reaction_39_1(IKKbeta_activ_by_ROS,ROS), z=(IKKbeta_activ_by_ROS*ROS);end

function z=function_4_reaction_41_1(Amino_Acids,IKKbeta,mTORC1,mTORC1_S2448_phos_by_AA_n_IKKbeta), z=(mTORC1_S2448_phos_by_AA_n_IKKbeta*mTORC1*Amino_Acids*IKKbeta);end

% adding few functions representing operators used in SBML but not present directly 
% in either matlab or octave. 
function z=pow(x,y),z=x^y;end
function z=root(x,y),z=y^(1/x);end
function z = piecewise(varargin)
	numArgs = nargin;
	result = 0;
	foundResult = 0;
	for k=1:2: numArgs-1
		if varargin{k+1} == 1
			result = varargin{k};
			foundResult = 1;
			break;
		end
	end
	if foundResult == 0
		result = varargin{numArgs};
	end
	z = result;
end


