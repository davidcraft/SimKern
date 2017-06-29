% This file works with MATLAB and is automatically generated with 
% the System Biology Format Converter (http://sbfc.sourceforge.net/)
% from an SBML file. 
% To run this file with Octave you must edit the comments providing
% the definition of the ode solver and the signature for the 
% xdot function.
%
% The conversion system has the following limitations:
%  - You may have to re order some reactions and Assignment Rules definition
%  - Delays are not taken into account
%  - You should change the lsode parameters (start, end, steps) to get better results
%

%
% Model name = Conradie2010_RPControl_CellCycle
%
% is http://identifiers.org/biomodels.db/MODEL1008240000
% is http://identifiers.org/biomodels.db/BIOMD0000000265
% isDescribedBy http://identifiers.org/pubmed/20015233
% isDerivedFrom http://identifiers.org/pubmed/15363676
%


function main()
%Initial conditions vector
	x0=zeros(23,1);
	x0(1) = 0.00220177;
	x0(2) = 6.53278E-4;
	x0(3) = 1.4094;
	x0(4) = 2.72898;
	x0(5) = 0.43929;
	x0(6) = 0.0229112;
	x0(7) = 0.900533;
	x0(8) = 0.989986;
	x0(9) = 0.00478911;
	x0(10) = 0.0121809;
	x0(11) = 1.35565;
	x0(12) = 9.97574;
	x0(13) = 2.36733;
	x0(14) = 1.68776;
	x0(15) = 0.00922806;
	x0(16) = 0.0356927;
	x0(17) = 0.010976;
	x0(18) = 5.42587E-4;
	x0(19) = 3.98594;
	x0(20) = 0.0192822;
	x0(21) = 0.154655;
	x0(22) = 1.0;
	x0(23) = 1.90871E-4;


% Depending on whether you are using Octave or Matlab,
% you should comment / uncomment one of the following blocks.
% This should also be done for the definition of the function f below.
% Start Matlab code
	tspan=[0:0.01:10];
	opts = odeset('AbsTol',1e-3);
	[t,x]=ode23tb(@f,tspan,x0,opts);
% End Matlab code

% Start Octave code
%	t=linspace(0,100,100);
%	x=lsode('f',x0,t);
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
%function xdot=f(x,t)
% End Octave code

% Compartment: id = cell, name = cell, constant
	compartment_cell=1.0;
% Parameter:   id =  Flag, name = Flag
	global_par_Flag=1.0;
% Parameter:   id =  r31switch, name = r31switch
	global_par_r31switch=1.0;
% Parameter:   id =  PP1A, name = PP1A
% Parameter:   id =  V2, name = V2
% Parameter:   id =  V4, name = V4
% Parameter:   id =  V6, name = V6
% Parameter:   id =  V8, name = V8
% Parameter:   id =  CYCET, name = CYCET
% Parameter:   id =  CYCDT, name = CYCDT
% Parameter:   id =  CYCAT, name = CYCAT
% Parameter:   id =  P27T, name = P27T
% Parameter:   id =  K10, name = K10
	global_par_K10=5.0;
% Parameter:   id =  K8a, name = K8a
	global_par_K8a=0.1;
% Parameter:   id =  K8, name = K8
	global_par_K8=2.0;
% Parameter:   id =  K25, name = K25
	global_par_K25=1000.0;
% Parameter:   id =  K25R, name = K25R
	global_par_K25R=10.0;
% Parameter:   id =  J8, name = J8
	global_par_J8=0.1;
% Parameter:   id =  YE, name = YE
	global_par_YE=1.0;
% Parameter:   id =  YB, name = YB
	global_par_YB=0.05;
% Parameter:   id =  K30, name = K30
	global_par_K30=20.0;
% Parameter:   id =  K2a, name = K2a
	global_par_K2a=0.05;
% Parameter:   id =  K2, name = K2
	global_par_K2=20.0;
% Parameter:   id =  K2aa, name = K2aa
	global_par_K2aa=1.0;
% Parameter:   id =  K6a, name = K6a
	global_par_K6a=10.0;
% Parameter:   id =  K6, name = K6
	global_par_K6=100.0;
% Parameter:   id =  HE, name = HE
	global_par_HE=0.5;
% Parameter:   id =  HB, name = HB
	global_par_HB=1.0;
% Parameter:   id =  HA, name = HA
	global_par_HA=0.5;
% Parameter:   id =  RBT, name = RBT
	global_par_RBT=10.0;
% Parameter:   id =  LD, name = LD
	global_par_LD=3.3;
% Parameter:   id =  LE, name = LE
	global_par_LE=5.0;
% Parameter:   id =  LB, name = LB
	global_par_LB=5.0;
% Parameter:   id =  LA, name = LA
	global_par_LA=3.0;
% Parameter:   id =  K20, name = K20
	global_par_K20=10.0;
% Parameter:   id =  K21, name = K21
	global_par_K21=1.0;
% Parameter:   id =  PP1T, name = PP1T
	global_par_PP1T=1.0;
% Parameter:   id =  FE, name = FE
	global_par_FE=25.0;
% Parameter:   id =  FB, name = FB
	global_par_FB=2.0;
% Parameter:   id =  K4, name = K4
	global_par_K4=40.0;
% Parameter:   id =  GE, name = GE
	global_par_GE=0.0;
% Parameter:   id =  GB, name = GB
	global_par_GB=1.0;
% Parameter:   id =  GA, name = GA
	global_par_GA=0.3;
% Parameter:   id =  K12, name = K12
	global_par_K12=1.5;
% Parameter:   id =  E2FT, name = E2FT
	global_par_E2FT=5.0;
% Parameter:   id =  K22, name = K22
	global_par_K22=1.0;
% Parameter:   id =  K23a, name = K23a
	global_par_K23a=0.005;
% Parameter:   id =  K23, name = K23
	global_par_K23=1.0;
% Parameter:   id =  K26, name = K26
	global_par_K26=10000.0;
% Parameter:   id =  K26R, name = K26R
	global_par_K26R=200.0;
% Parameter:   id =  eps, name = eps
	global_par_eps=1.0;
% assignmentRule: variable = CYCET
	global_par_CYCET=x(18)+x(6);
% assignmentRule: variable = CYCDT
	global_par_CYCDT=x(17)+x(5);
% assignmentRule: variable = CYCAT
	global_par_CYCAT=x(16)+x(3);
% assignmentRule: variable = P27T
	global_par_P27T=x(16)+x(17)+x(18)+x(15);

% assignmentRule: variable = PP1A
	global_par_PP1A=global_par_PP1T/(1+global_par_K21*(global_par_FB*x(4)+global_par_FE*(x(3)+x(6))));
% assignmentRule: variable = V2
	global_par_V2=global_par_K2aa*x(1)+global_par_K2a*(1-x(2))+global_par_K2*x(2);
% assignmentRule: variable = V4
	global_par_V4=global_par_K4*(global_par_GA*x(3)+global_par_GB*x(4)+global_par_GE*x(6));
% assignmentRule: variable = V6
	global_par_V6=global_par_K6a+global_par_K6*(global_par_HA*x(3)+global_par_HB*x(4)+global_par_HE*x(6));
% assignmentRule: variable = V8
	global_par_V8=global_par_K8a+global_par_K8*(global_par_YB*x(4)+global_par_YE*(x(3)+x(6)))/(global_par_CYCET+global_par_J8);

% Reaction: id = v1, name = v1	% Local Parameter:   id =  k16, name = k16
	reaction_v1_k16=0.25;

	reaction_v1=reaction_v1_k16*x(10);

% Reaction: id = v2, name = v2	% Local Parameter:   id =  k18, name = k18
	reaction_v2_k18=10.0;

	reaction_v2=reaction_v2_k18*x(7);

% Reaction: id = v3, name = v3
	reaction_v3=global_par_K10*x(17);

% Reaction: id = v4, name = v4
	reaction_v4=global_par_K10*x(5);

% Reaction: id = v5, name = v5
	reaction_v5=global_par_K25*x(6)*x(15);

% Reaction: id = v6, name = v6
	reaction_v6=global_par_K25*x(3)*x(15);

% Reaction: id = v7, name = v7	% Local Parameter:   id =  k24, name = k24
	reaction_v7_k24=1000.0;

	reaction_v7=reaction_v7_k24*x(5)*x(15);

% Reaction: id = v8, name = v8	% Local Parameter:   id =  k24r, name = k24r
	reaction_v8_k24r=10.0;

	reaction_v8=reaction_v8_k24r*x(17);

% Reaction: id = v9, name = v9
	reaction_v9=global_par_K30*x(1)*x(3);

% Reaction: id = v10, name = v10
	reaction_v10=global_par_K30*x(16)*x(1);

% Reaction: id = v11, name = v11
	reaction_v11=global_par_K25R*x(18);

% Reaction: id = v12, name = v12
	reaction_v12=global_par_K25R*x(16);

% Reaction: id = v13, name = v13
	reaction_v13=global_par_V8*x(18);

% Reaction: id = v14, name = v14
	reaction_v14=global_par_V8*x(6);

% Reaction: id = v15, name = v15
	reaction_v15=global_par_V6*x(15);

% Reaction: id = v16, name = v16
	reaction_v16=global_par_V6*x(18);

% Reaction: id = v17, name = v17
	reaction_v17=global_par_V6*x(17);

% Reaction: id = v18, name = v18
	reaction_v18=global_par_V6*x(16);

% Reaction: id = v19, name = v19
	reaction_v19=global_par_V2*x(4);

% Reaction: id = v20, name = v20	% Local Parameter:   id =  J3, name = J3
	reaction_v20_J3=0.01;
	% Local Parameter:   id =  K3, name = K3
	reaction_v20_K3=140.0;
	% Local Parameter:   id =  K3a, name = K3a
	reaction_v20_K3a=7.5;

	reaction_v20=(reaction_v20_K3a+reaction_v20_K3*x(1))*(1-x(2))/(1+reaction_v20_J3-x(2));

% Reaction: id = v21, name = v21	% Local Parameter:   id =  J4, name = J4
	reaction_v21_J4=0.01;

	reaction_v21=global_par_V4*x(2)/(reaction_v21_J4+x(2));

% Reaction: id = v22, name = v22	% Local Parameter:   id =  K34, name = K34
	reaction_v22_K34=0.05;

	reaction_v22=reaction_v22_K34*x(22);

% Reaction: id = v23, name = v23	% Local Parameter:   id =  J31, name = J31
	reaction_v23_J31=0.01;
	% Local Parameter:   id =  K31, name = K31
	reaction_v23_K31=0.7;

	reaction_v23=reaction_v23_K31*x(4)*(1-x(21))/(1+reaction_v23_J31-x(21));

% Reaction: id = v24, name = v24	% Local Parameter:   id =  J32, name = J32
	reaction_v24_J32=0.01;
	% Local Parameter:   id =  K32, name = K32
	reaction_v24_K32=1.8;

	reaction_v24=reaction_v24_K32*x(21)*x(22)/(reaction_v24_J32+x(21));

% Reaction: id = v25, name = v25
	reaction_v25=global_par_K12*x(13);

% Reaction: id = v26, name = v26	% Local Parameter:   id =  J13, name = J13
	reaction_v26_J13=0.005;
	% Local Parameter:   id =  K13, name = K13
	reaction_v26_K13=5.0;

	reaction_v26=reaction_v26_K13*(-x(1)+x(13))*x(21)/(reaction_v26_J13-x(1)+x(13));

% Reaction: id = v27, name = v27	% Local Parameter:   id =  J14, name = J14
	reaction_v27_J14=0.005;
	% Local Parameter:   id =  K14, name = K14
	reaction_v27_K14=2.5;

	reaction_v27=reaction_v27_K14*x(1)/(reaction_v27_J14+x(1));

% Reaction: id = v28, name = v28
	reaction_v28=global_par_K12*x(1);

% Reaction: id = v29, name = v29
	reaction_v29=global_par_K20*(global_par_LA*x(3)+global_par_LB*x(4)+global_par_LD*(x(17)+x(5))+global_par_LE*x(6))*x(9);

% Reaction: id = v30, name = v30
	reaction_v30=global_par_K20*(global_par_LA*x(3)+global_par_LB*x(4)+global_par_LD*(x(17)+x(5))+global_par_LE*x(6))*x(20);

% Reaction: id = v31, name = v31	% Local Parameter:   id =  K27, name = K27
	reaction_v31_K27=0.2;

	reaction_v31=reaction_v31_K27*x(14)*global_par_r31switch;

% Reaction: id = v32, name = v32	% Local Parameter:   id =  K28, name = K28
	reaction_v32_K28=0.2;

	reaction_v32=reaction_v32_K28*x(11);

% Reaction: id = v33, name = v33	% Local Parameter:   id =  MU, name = MU
	reaction_v33_MU=0.061;

	reaction_v33=global_par_eps*reaction_v33_MU*x(11);

% Reaction: id = v34, name = v34	% Local Parameter:   id =  J15, name = J15
	reaction_v34_J15=0.1;
	% Local Parameter:   id =  k15, name = k15
	reaction_v34_k15=0.25;

	reaction_v34=global_par_eps*reaction_v34_k15/(1+x(7)^2/reaction_v34_J15^2);

% Reaction: id = v35, name = v35	% Local Parameter:   id =  K11, name = K11
	reaction_v35_K11=1.5;
	% Local Parameter:   id =  K11a, name = K11a
	reaction_v35_K11a=0.0;

	reaction_v35=global_par_eps*(reaction_v35_K11a+reaction_v35_K11*x(4));

% Reaction: id = v36, name = v36	% Local Parameter:   id =  K29, name = K29
	reaction_v36_K29=0.05;

	reaction_v36=global_par_eps*reaction_v36_K29*x(14)*x(8);

% Reaction: id = v37, name = v37	% Local Parameter:   id =  K33, name = K33
	reaction_v37_K33=0.05;

	reaction_v37=global_par_eps*reaction_v37_K33;

% Reaction: id = v38, name = v38	% Local Parameter:   id =  K7, name = K7
	reaction_v38_K7=0.6;
	% Local Parameter:   id =  K7a, name = K7a
	reaction_v38_K7a=0.0;

	reaction_v38=global_par_eps*(reaction_v38_K7a+reaction_v38_K7*x(8));

% Reaction: id = v39, name = v39	% Local Parameter:   id =  K9, name = K9
	reaction_v39_K9=2.5;

	reaction_v39=global_par_eps*reaction_v39_K9*x(7);

% Reaction: id = v40, name = v40	% Local Parameter:   id =  K5, name = K5
	reaction_v40_K5=20.0;

	reaction_v40=global_par_eps*reaction_v40_K5;

% Reaction: id = v41, name = v41	% Local Parameter:   id =  J17, name = J17
	reaction_v41_J17=0.3;
	% Local Parameter:   id =  k17, name = k17
	reaction_v41_k17=10.0;
	% Local Parameter:   id =  k17a, name = k17a
	reaction_v41_k17a=0.35;

	reaction_v41=global_par_eps*(reaction_v41_k17*x(7)^2/(reaction_v41_J17^2*(1+x(7)^2/reaction_v41_J17^2))+reaction_v41_k17a*x(10));

% Reaction: id = v42, name = v42	% Local Parameter:   id =  J1, name = J1
	reaction_v42_J1=0.1;
	% Local Parameter:   id =  K1, name = K1
	reaction_v42_K1=0.6;
	% Local Parameter:   id =  K1a, name = K1a
	reaction_v42_K1a=0.1;

	reaction_v42=global_par_eps*(reaction_v42_K1a+reaction_v42_K1*x(4)^2/(reaction_v42_J1^2*(1+x(4)^2/reaction_v42_J1^2)));

% Reaction: id = v43, name = v43
	reaction_v43=global_par_K20*(global_par_LA*x(3)+global_par_LB*x(4)+global_par_LD*(x(17)+x(5))+global_par_LE*x(6))*x(23);

% Reaction: id = v44, name = v44	% Local Parameter:   id =  K19, name = K19
	reaction_v44_K19=20.0;
	% Local Parameter:   id =  K19a, name = K19a
	reaction_v44_K19a=0.0;

	reaction_v44=(reaction_v44_K19*global_par_PP1A+reaction_v44_K19a*(global_par_PP1T-global_par_PP1A))*x(12);

% Reaction: id = v45, name = v45
	reaction_v45=global_par_K26R*x(9);

% Reaction: id = v46, name = v46
	reaction_v46=(global_par_K23a+global_par_K23*(x(3)+x(4)))*x(8);

% Reaction: id = v47, name = v47
	reaction_v47=global_par_K22*x(19);

% Reaction: id = v48, name = v48
	reaction_v48=global_par_K26*x(8)*x(23);

% Reaction: id = v49, name = v49
	reaction_v49=global_par_K26R*x(20);

% Reaction: id = v50, name = v50
	reaction_v50=global_par_K26*x(19)*x(23);

% Reaction: id = v51, name = v51
	reaction_v51=global_par_K22*x(20);

% Reaction: id = v52, name = v52
	reaction_v52=(global_par_K23a+global_par_K23*(x(3)+x(4)))*x(9);

%Event: id=r31Ifpart1
	event_r31Ifpart1=((x(23)+x(9)+x(20))*(x(12)+x(23)+x(9)+x(20))^(-1)) > 0.8;

	if(event_r31Ifpart1) 
		global_par_r31switch=0;
	end

%Event: id=r31Ifpart2
	event_r31Ifpart2=((x(23)+x(9)+x(20))*(x(12)+x(23)+x(9)+x(20))^(-1)) < 0.8;

	if(event_r31Ifpart2) 
		global_par_r31switch=1;
	end

%Event: id=divisionEvent
	event_divisionEvent=(x(2) > 0.2) && (global_par_Flag == 1);

	if(event_divisionEvent) 
		x(11)=0.5*x(11);
		x(14)=0.5*x(14);
		global_par_Flag=2;
	end

%Event: id=checkEvent
	event_checkEvent=(x(2) < 0.2) && (global_par_Flag == 2);

	if(event_checkEvent) 
		global_par_Flag=1;
	end

	xdot=zeros(23,1);
	
% Species:   id = CDc20, name = Cdc20, affected by kineticLaw
	xdot(1) = (1/(compartment_cell))*(( 1.0 * reaction_v26) + (-1.0 * reaction_v27) + (-1.0 * reaction_v28));
	
% Species:   id = CDh1, name = Cdh1, affected by kineticLaw
	xdot(2) = (1/(compartment_cell))*(( 1.0 * reaction_v20) + (-1.0 * reaction_v21));
	
% Species:   id = CYCA, name = cyclin A:Cdk2, affected by kineticLaw
	xdot(3) = (1/(compartment_cell))*((-1.0 * reaction_v6) + (-1.0 * reaction_v9) + ( 1.0 * reaction_v12) + ( 1.0 * reaction_v18) + ( 1.0 * reaction_v36));
	
% Species:   id = CYCB, name = cyclin B:Cdk2, affected by kineticLaw
	xdot(4) = (1/(compartment_cell))*((-1.0 * reaction_v19) + ( 1.0 * reaction_v42));
	
% Species:   id = CYCD, name = cyclin D:Cdk2, affected by kineticLaw
	xdot(5) = (1/(compartment_cell))*((-1.0 * reaction_v4) + (-1.0 * reaction_v7) + ( 1.0 * reaction_v8) + ( 1.0 * reaction_v17) + ( 1.0 * reaction_v39));
	
% Species:   id = CYCE, name = cyclin E:Cdk2, affected by kineticLaw
	xdot(6) = (1/(compartment_cell))*((-1.0 * reaction_v5) + ( 1.0 * reaction_v11) + (-1.0 * reaction_v14) + ( 1.0 * reaction_v16) + ( 1.0 * reaction_v38));
	
% Species:   id = DRG, name = delayed-response genes, affected by kineticLaw
	xdot(7) = (1/(compartment_cell))*((-1.0 * reaction_v2) + ( 1.0 * reaction_v41));
	
% Species:   id = var2, name = E2F, affected by kineticLaw
	xdot(8) = (1/(compartment_cell))*(( 1.0 * reaction_v29) + ( 1.0 * reaction_v45) + (-1.0 * reaction_v46) + ( 1.0 * reaction_v47) + (-1.0 * reaction_v48));
	
% Species:   id = var5, name = E2F:Rb, affected by kineticLaw
	xdot(9) = (1/(compartment_cell))*((-1.0 * reaction_v29) + (-1.0 * reaction_v45) + ( 1.0 * reaction_v48) + ( 1.0 * reaction_v51) + (-1.0 * reaction_v52));
	
% Species:   id = ERG, name = early-response genes, affected by kineticLaw
	xdot(10) = (1/(compartment_cell))*((-1.0 * reaction_v1) + ( 1.0 * reaction_v34));
	
% Species:   id = GM, name = general machinery for protein synthesis, affected by kineticLaw
	xdot(11) = (1/(compartment_cell))*(( 1.0 * reaction_v31) + (-1.0 * reaction_v32));
	
% Species:   id = var1, name = hypophosphorylated Rb, affected by kineticLaw
	xdot(12) = (1/(compartment_cell))*(( 1.0 * reaction_v29) + ( 1.0 * reaction_v30) + ( 1.0 * reaction_v43) + (-1.0 * reaction_v44));
	
% Species:   id = CDc20T, name = inactive Cdc20, affected by kineticLaw
	xdot(13) = (1/(compartment_cell))*((-1.0 * reaction_v25) + ( 1.0 * reaction_v35));
	
% Species:   id = MASS, name = mass, affected by kineticLaw
	xdot(14) = (1/(compartment_cell))*(( 1.0 * reaction_v33));
	
% Species:   id = P27, name = P27, affected by kineticLaw
	xdot(15) = (1/(compartment_cell))*(( 1.0 * reaction_v3) + (-1.0 * reaction_v5) + (-1.0 * reaction_v6) + (-1.0 * reaction_v7) + ( 1.0 * reaction_v8) + ( 1.0 * reaction_v10) + ( 1.0 * reaction_v11) + ( 1.0 * reaction_v12) + ( 1.0 * reaction_v13) + (-1.0 * reaction_v15) + ( 1.0 * reaction_v40));
	
% Species:   id = CA, name = P27:cyclin A:Cdk2, affected by kineticLaw
	xdot(16) = (1/(compartment_cell))*(( 1.0 * reaction_v6) + (-1.0 * reaction_v10) + (-1.0 * reaction_v12) + (-1.0 * reaction_v18));
	
% Species:   id = CD, name = P27:cyclin D:Cdk2, affected by kineticLaw
	xdot(17) = (1/(compartment_cell))*((-1.0 * reaction_v3) + ( 1.0 * reaction_v7) + (-1.0 * reaction_v8) + (-1.0 * reaction_v17));
	
% Species:   id = CE, name = P27:cyclin E:Cdk2, affected by kineticLaw
	xdot(18) = (1/(compartment_cell))*(( 1.0 * reaction_v5) + (-1.0 * reaction_v11) + (-1.0 * reaction_v13) + (-1.0 * reaction_v16));
	
% Species:   id = var3, name = phosphorylated E2F, affected by kineticLaw
	xdot(19) = (1/(compartment_cell))*(( 1.0 * reaction_v30) + ( 1.0 * reaction_v46) + (-1.0 * reaction_v47) + ( 1.0 * reaction_v49) + (-1.0 * reaction_v50));
	
% Species:   id = var6, name = phosphorylated E2F:Rb, affected by kineticLaw
	xdot(20) = (1/(compartment_cell))*((-1.0 * reaction_v30) + (-1.0 * reaction_v49) + ( 1.0 * reaction_v50) + (-1.0 * reaction_v51) + ( 1.0 * reaction_v52));
	
% Species:   id = IEP, name = phosphorylated intermediary enzyme, affected by kineticLaw
	xdot(21) = (1/(compartment_cell))*(( 1.0 * reaction_v23) + (-1.0 * reaction_v24));
	
% Species:   id = PPX, name = PPX, affected by kineticLaw
	xdot(22) = (1/(compartment_cell))*((-1.0 * reaction_v22) + ( 1.0 * reaction_v37));
	
% Species:   id = var4, name = retinoblastoma protein (Rb), affected by kineticLaw
	xdot(23) = (1/(compartment_cell))*((-1.0 * reaction_v43) + ( 1.0 * reaction_v44) + ( 1.0 * reaction_v45) + (-1.0 * reaction_v48) + ( 1.0 * reaction_v49) + (-1.0 * reaction_v50));
end

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


