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
% Model name = Kim2007 - Crosstalk between Wnt and ERK pathways
%
% is http://identifiers.org/biomodels.db/MODEL4159212701
% is http://identifiers.org/biomodels.db/BIOMD0000000149
% isDescribedBy http://identifiers.org/pubmed/17237813
% isDerivedFrom http://identifiers.org/pubmed/14551908
% isDerivedFrom http://identifiers.org/doi/10.1007/3-540-36481-1_11
%


function main()
%Initial conditions vector
	x0=zeros(28,1);
	x0(1) = 100.0;
	x0(2) = 0.0;
	x0(3) = 0.0153;
	x0(4) = 0.0076;
	x0(5) = 49.1372;
	x0(6) = 0.0015;
	x0(7) = 96.6019;
	x0(8) = 0.002;
	x0(9) = 0.002;
	x0(10) = 0.9881;
	x0(11) = 42.7224;
	x0(12) = 8.0E-4;
	x0(13) = 6.1879;
	x0(14) = 8.8121;
	x0(15) = 3.4392;
	x0(16) = 200.0;
	x0(17) = 0.0;
	x0(18) = 112.5585;
	x0(19) = 6.486;
	x0(20) = 296.1137;
	x0(21) = 3.8863;
	x0(22) = 297.8897;
	x0(23) = 2.1103;
	x0(24) = 180.9595;
	x0(25) = 418.1788;
	x0(26) = 0.8619;
	x0(27) = 10.263;
	x0(28) = 0.85544;


% Depending on whether you are using Octave or Matlab,
% you should comment / uncomment one of the following blocks.
% This should also be done for the definition of the function f below.
% Start Matlab code
%	tspan=[0:0.01:100];
%	opts = odeset('AbsTol',1e-3);
%	[t,x]=ode23tb(@f,tspan,x0,opts);
% End Matlab code

% Start Octave code
	t=linspace(0,100,100);
	x=lsode('f',x0,t);
% End Octave code

%here I will just print out to the system terminal (stdout) the
%0/1 result. note could also write a file, but this is easier.
%could runs this out put into a file by calling this like oc
    disp(x(end, end) > 0.85);
end



% Depending on whether you are using Octave or Matlab,
% you should comment / uncomment one of the following blocks.
% This should also be done for the definition of the function f below.
% Start Matlab code
%function xdot=f(t,x)
% End Matlab code

% Start Octave code
function xdot=f(x,t)
% End Octave code

% Compartment: id = cytoplasm, name = cytoplasm, constant
	compartment_cytoplasm=$uniform(.1,.2),name=k1$;
% Compartment: id = nucleus, name = nucleus, constant
	compartment_nucleus=$gauss(0,1),name=k2$;
% Parameter:   id =  k1, name = k1
	global_par_k1=0.182;
% Parameter:   id =  W, name = W
	global_par_W=0.0;
% Parameter:   id =  k2, name = k2
	global_par_k2=0.0182;
% Parameter:   id =  k3, name = k3
	global_par_k3=0.05;
% Parameter:   id =  k4, name = k4
	global_par_k4=0.267;
% Parameter:   id =  k5, name = k5
	global_par_k5=0.133;
% Parameter:   id =  k_plus6, name = k_plus6
	global_par_k_plus6=0.0909;
% Parameter:   id =  k_minus6, name = k_minus6
	global_par_k_minus6=0.909;
% Parameter:   id =  k_plus7, name = k_plus7
	global_par_k_plus7=1.0;
% Parameter:   id =  k_minus7, name = k_minus7
	global_par_k_minus7=50.0;
% Parameter:   id =  k_plus8, name = k_plus8
	global_par_k_plus8=1.0;
% Parameter:   id =  k_minus8, name = k_minus8
	global_par_k_minus8=120.0;
% Parameter:   id =  k9, name = k9
	global_par_k9=206.0;
% Parameter:   id =  k10, name = k10
	global_par_k10=206.0;
% Parameter:   id =  k11, name = k11
	global_par_k11=0.417;
% Parameter:   id =  V12, name = V12
	global_par_V12=0.423;
% Parameter:   id =  k13, name = k13
	global_par_k13=2.57E-4;
% Parameter:   id =  k14, name = k14
	global_par_k14=8.22E-5;
% Parameter:   id =  k21, name = k21
	global_par_k21=1.0E-6;
% Parameter:   id =  k15, name = k15
	global_par_k15=0.167;
% Parameter:   id =  k_plus16, name = k_plus16
	global_par_k_plus16=1.0;
% Parameter:   id =  k_minus16, name = k_minus16
	global_par_k_minus16=30.0;
% Parameter:   id =  k_plus17, name = k_plus17
	global_par_k_plus17=1.0;
% Parameter:   id =  k_minus17, name = k_minus17
	global_par_k_minus17=1200.0;
% Parameter:   id =  Vmax1, name = Vmax1
	global_par_Vmax1=150.0;
% Parameter:   id =  Km1, name = Km1
	global_par_Km1=10.0;
% Parameter:   id =  Ki, name = Ki
	global_par_Ki=9.0;
% Parameter:   id =  Vmax2, name = Vmax2
	global_par_Vmax2=15.0;
% Parameter:   id =  Km2, name = Km2
	global_par_Km2=8.0;
% Parameter:   id =  kcat1, name = kcat1
	global_par_kcat1=1.5;
% Parameter:   id =  Km3, name = Km3
	global_par_Km3=15.0;
% Parameter:   id =  Vmax3, name = Vmax3
	global_par_Vmax3=45.0;
% Parameter:   id =  Km4, name = Km4
	global_par_Km4=15.0;
% Parameter:   id =  kcat2, name = kcat2
	global_par_kcat2=1.5;
% Parameter:   id =  Km5, name = Km5
	global_par_Km5=15.0;
% Parameter:   id =  Vmax4, name = Vmax4
	global_par_Vmax4=45.0;
% Parameter:   id =  Km6, name = Km6
	global_par_Km6=15.0;
% Parameter:   id =  kcat3, name = kcat3
	global_par_kcat3=1.5;
% Parameter:   id =  Km7, name = Km7
	global_par_Km7=15.0;
% Parameter:   id =  Vmax5, name = Vmax5
	global_par_Vmax5=45.0;
% Parameter:   id =  Km8, name = Km8
	global_par_Km8=15.0;
% Parameter:   id =  kcat4, name = kcat4
	global_par_kcat4=1.5;
% Parameter:   id =  Km9, name = Km9
	global_par_Km9=9.0;
% Parameter:   id =  k18, name = k18
	global_par_k18=0.15;
% Parameter:   id =  k19, name = k19
	global_par_k19=39.0;
% Parameter:   id =  Vmax6, name = Vmax6
	global_par_Vmax6=45.0;
% Parameter:   id =  Km10, name = Km10
	global_par_Km10=12.0;
% Parameter:   id =  kcat5, name = kcat5
	global_par_kcat5=0.6;
% Parameter:   id =  n1, name = n1
	global_par_n1=2.0;
% Parameter:   id =  Km11, name = Km11
	global_par_Km11=15.0;
% Parameter:   id =  k20, name = k20
	global_par_k20=0.015;
% Parameter:   id =  kcat6, name = kcat6
	global_par_kcat6=1.5;
% Parameter:   id =  Km12, name = Km12
	global_par_Km12=15.0;
% Parameter:   id =  kcat7, name = kcat7
	global_par_kcat7=1.5;
% Parameter:   id =  Km13, name = Km13
	global_par_Km13=15.0;
% Parameter:   id =  Vmax7, name = Vmax7
	global_par_Vmax7=45.0;
% Parameter:   id =  Km14, name = Km14
	global_par_Km14=15.0;
% Parameter:   id =  flag_for_wnt_signal, name = flag_for_wnt_signal
% Warning parameter flag_for_wnt_signal is not constant, it should be controlled by a Rule and/or events
	global_par_flag_for_wnt_signal=0.0;
% Parameter:   id =  X13X14, name = X13X14
% assignmentRule: variable = X13X14
	global_par_X13X14=x(13)+x(14);

% Reaction: id = R1, name = Dishevelled activation
	reaction_R1=compartment_cytoplasm*global_par_k1*x(1)*global_par_W;

% Reaction: id = R2, name = Dishevelled inactivation
	reaction_R2=compartment_cytoplasm*global_par_k2*x(2);

% Reaction: id = R3, name = Dishevelled mediated GSK/Axin/APC complex disassembly
	reaction_R3=compartment_cytoplasm*global_par_k3*x(2)*x(4);

% Reaction: id = R4, name = Activation of GSK/Axin/APC complex
	reaction_R4=compartment_cytoplasm*global_par_k4*x(4);

% Reaction: id = R5, name = Inactivation of GSK/Axin/APC complex
	reaction_R5=compartment_cytoplasm*global_par_k5*x(3);

% Reaction: id = R6, name = GSK/Axin/APC complex reassembly
	reaction_R6=compartment_cytoplasm*(global_par_k_plus6*x(5)*x(6)-global_par_k_minus6*x(4));

% Reaction: id = R7, name = Axin/APC complex formation
	reaction_R7=compartment_cytoplasm*(global_par_k_plus7*x(7)*x(12)-global_par_k_minus7*x(6));

% Reaction: id = R8, name = bCatenin binding to GSK/Axin/APC complex
	reaction_R8=compartment_cytoplasm*(global_par_k_plus8*x(3)*x(11)-global_par_k_minus8*x(8));

% Reaction: id = R9, name = bCatenin phosphorylation
	reaction_R9=compartment_cytoplasm*global_par_k9*x(8);

% Reaction: id = R10, name = GSK.Axin/APC/bCatenin complex disassembly
	reaction_R10=compartment_cytoplasm*global_par_k10*x(9);

% Reaction: id = R11, name = Phosphorylated bCatenin degradation
	reaction_R11=compartment_cytoplasm*global_par_k11*x(10);

% Reaction: id = R12, name = bCatenin synthesis
	reaction_R12=compartment_cytoplasm*global_par_V12;

% Reaction: id = R13, name = Unphosphorylated bCatenin degradation
	reaction_R13=compartment_nucleus*global_par_k13*x(11);

% Reaction: id = R14, name = Axin synthesis
	reaction_R14=compartment_nucleus*(global_par_k14+global_par_k21*(x(11)+x(14)));

% Reaction: id = R15, name = Axin degradation
	reaction_R15=compartment_cytoplasm*global_par_k15*x(12);

% Reaction: id = R16, name = bCatenin/TCF complex formation
	reaction_R16=compartment_nucleus*(global_par_k_plus16*x(11)*x(13)-global_par_k_minus16*x(14));

% Reaction: id = R17, name = APC/bCatenin complex formation
	reaction_R17=compartment_cytoplasm*(global_par_k_plus17*x(7)*x(11)-global_par_k_minus17*x(15));

% Reaction: id = R18, name = Ras activation
	reaction_R18=compartment_cytoplasm*global_par_Vmax1*x(16)*global_par_W/(global_par_Km1+x(16))*global_par_Ki/(global_par_Ki+x(23));

% Reaction: id = R19, name = Ras inactivation
	reaction_R19=compartment_cytoplasm*global_par_Vmax2*x(17)/(global_par_Km2+x(17));

% Reaction: id = R20, name = Raf activation
	reaction_R20=compartment_cytoplasm*global_par_kcat1*x(17)*x(18)/(global_par_Km3+x(18));

% Reaction: id = R21, name = Raf inactivation
	reaction_R21=compartment_cytoplasm*global_par_Vmax3*x(19)/(global_par_Km4+x(19));

% Reaction: id = R22, name = MEK activation
	reaction_R22=compartment_cytoplasm*global_par_kcat2*x(19)*x(20)/(global_par_Km5+x(20));

% Reaction: id = R23, name = MEK inactivation
	reaction_R23=compartment_cytoplasm*global_par_Vmax4*x(21)/(global_par_Km6+x(21));

% Reaction: id = R24, name = ERK activation
	reaction_R24=compartment_cytoplasm*global_par_kcat3*x(21)*x(22)/(global_par_Km7+x(22));

% Reaction: id = R25, name = ERK inactivation
	reaction_R25=compartment_cytoplasm*global_par_Vmax5*x(23)/(global_par_Km8+x(23));

% Reaction: id = R26, name = Raf/RKIP complex disassembly
	reaction_R26=compartment_cytoplasm*global_par_kcat4*x(23)*x(24)/(global_par_Km9+x(24));

% Reaction: id = R27, name = Raf-RKIP complex formation
	reaction_R27=compartment_cytoplasm*(global_par_k18*x(18)*x(25)-global_par_k19*x(24));

% Reaction: id = R28, name = RKIP dephosphorylation
	reaction_R28=compartment_cytoplasm*global_par_Vmax6*x(26)/(global_par_Km10+x(26));

% Reaction: id = R29, name = Unknown factor-X formation
	reaction_R29=compartment_cytoplasm*global_par_kcat5*x(14)^global_par_n1/(global_par_Km11^global_par_n1+x(14)^global_par_n1);

% Reaction: id = R30, name = Factor-X degradation
	reaction_R30=compartment_cytoplasm*global_par_k20*x(27);

% Reaction: id = R31, name = Factor-X mediated Raf activation
	reaction_R31=compartment_cytoplasm*global_par_kcat6*x(27)*x(18)/(global_par_Km12+x(18));

% Reaction: id = R32, name = ERK mediated GSK3beta phosphorylation
	reaction_R32=compartment_cytoplasm*global_par_kcat7*x(23)*x(5)/(global_par_Km13+x(5));

% Reaction: id = R33, name = GSK3beta dephosphorylation
	reaction_R33=compartment_cytoplasm*global_par_Vmax7*x(28)/(global_par_Km14+x(28));

%Event: id=event_0000001
	event_event_0000001=(t >= 500) && (t <= 1000);

	if(event_event_0000001)
		global_par_W=1;
	end

%Event: id=event_0000002
	event_event_0000002=t > 1000;

	if(event_event_0000002)
		global_par_W=0;
	end

	xdot=zeros(28,1);

% Species:   id = X1, name = Dshi, affected by kineticLaw
	xdot(1) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R1) + ( 1.0 * reaction_R2));

% Species:   id = X2, name = Dsha, affected by kineticLaw
	xdot(2) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R1) + (-1.0 * reaction_R2));

% Species:   id = X3, name = APC_ast/Axin_ast/GSK3beta, affected by kineticLaw
	xdot(3) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R4) + (-1.0 * reaction_R5) + (-1.0 * reaction_R8) + ( 1.0 * reaction_R10));

% Species:   id = X4, name = APC/Axin/GSK3beta, affected by kineticLaw
	xdot(4) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R3) + (-1.0 * reaction_R4) + ( 1.0 * reaction_R5) + ( 1.0 * reaction_R6));

% Species:   id = X5, name = GSK3beta, affected by kineticLaw
	xdot(5) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R3) + (-1.0 * reaction_R6) + (-1.0 * reaction_R32) + ( 1.0 * reaction_R33));

% Species:   id = X6, name = APC/Axin, affected by kineticLaw
	xdot(6) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R3) + (-1.0 * reaction_R6) + ( 1.0 * reaction_R7));

% Species:   id = X7, name = APC, affected by kineticLaw
	xdot(7) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R7) + (-1.0 * reaction_R17));

% Species:   id = X8, name = bCatenin/APC_Ast/Axin_ast/GSK3beta, affected by kineticLaw
	xdot(8) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R8) + (-1.0 * reaction_R9));

% Species:   id = X9, name = bCatenin_ast/APC_ast/Axin_ast/GSK3beta, affected by kineticLaw
	xdot(9) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R9) + (-1.0 * reaction_R10));

% Species:   id = X10, name = bCatenin_ast, affected by kineticLaw
	xdot(10) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R10) + (-1.0 * reaction_R11));

% Species:   id = X11, name = bCatenin, affected by kineticLaw
	xdot(11) = (1/(compartment_nucleus))*((-1.0 * reaction_R8) + ( 1.0 * reaction_R12) + (-1.0 * reaction_R13) + (-1.0 * reaction_R16) + (-1.0 * reaction_R17));

% Species:   id = X12, name = Axin, affected by kineticLaw
	xdot(12) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R7) + ( 1.0 * reaction_R14) + (-1.0 * reaction_R15));

% Species:   id = X13, name = TCF, affected by kineticLaw
	xdot(13) = (1/(compartment_nucleus))*((-1.0 * reaction_R16));

% Species:   id = X14, name = bCatenin/TCF, affected by kineticLaw
	xdot(14) = (1/(compartment_nucleus))*(( 1.0 * reaction_R16));

% Species:   id = X15, name = bCatenin/APC, affected by kineticLaw
	xdot(15) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R17));

% Species:   id = X16, name = Rasi, affected by kineticLaw
	xdot(16) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R18) + ( 1.0 * reaction_R19));

% Species:   id = X17, name = Rasa, affected by kineticLaw
	xdot(17) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R18) + (-1.0 * reaction_R19));

% Species:   id = X18, name = Raf-1, affected by kineticLaw
	xdot(18) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R20) + ( 1.0 * reaction_R21) + ( 1.0 * reaction_R26) + (-1.0 * reaction_R27) + (-1.0 * reaction_R31));

% Species:   id = X19, name = Raf-1_ast, affected by kineticLaw
	xdot(19) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R20) + (-1.0 * reaction_R21) + ( 1.0 * reaction_R31));

% Species:   id = X20, name = MEK, affected by kineticLaw
	xdot(20) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R22) + ( 1.0 * reaction_R23));

% Species:   id = X21, name = MEK_ast, affected by kineticLaw
	xdot(21) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R22) + (-1.0 * reaction_R23));

% Species:   id = X22, name = ERK, affected by kineticLaw
	xdot(22) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R24) + ( 1.0 * reaction_R25));

% Species:   id = X23, name = ERK_ast, affected by kineticLaw
	xdot(23) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R24) + (-1.0 * reaction_R25));

% Species:   id = X24, name = Raf1/RKIP, affected by kineticLaw
	xdot(24) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R26) + ( 1.0 * reaction_R27));

% Species:   id = X25, name = RKIP, affected by kineticLaw
	xdot(25) = (1/(compartment_cytoplasm))*((-1.0 * reaction_R27) + ( 1.0 * reaction_R28));

% Species:   id = X26, name = RKIP_ast, affected by kineticLaw
	xdot(26) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R26) + (-1.0 * reaction_R28));

% Species:   id = X27, name = unknown molecule X, affected by kineticLaw
	xdot(27) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R29) + (-1.0 * reaction_R30));

% Species:   id = X28, name = GSK3beta, affected by kineticLaw
	xdot(28) = (1/(compartment_cytoplasm))*(( 1.0 * reaction_R32) + (-1.0 * reaction_R33));
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


