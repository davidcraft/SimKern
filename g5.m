function apopOctaveTest()
%Initial conditions vector

    x0 =  [0.488458
   0.911691
   0.400632
   0.692482
   0.388146
   0.423573
   0.383371
   0.159290
   0.868106
   0.824868
   0.645520
   0.344462
   0.632895
   0.019066
   0.830729
   0.695429
   0.223453
   0.527835
   0.693223
   0.966123
   0.686159
   0.011585
   0.318603
   0.662518
   0.355490
   0.553895
   0.667504
   0.736967
   0.904186
   0.358747
   0.570108
   0.752567
   0.336066
   0.272712
   0.911471
   0.401263
   0.614178
   0.355095
   0.260699
   0.527932
   0.369087
   0.190640
   0.177467
   0.221412
   0.545610
   0.424752
   0.762266];


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


%plot(t,x(:,[1 5 10 15 20]));
%        legend('1', '5', '10', '15', '20'); 

%here I will just print out to the system terminal (stdout) the
%0/1 result. note could also write a file, but this is easier.
%could runs this out put into a file by calling this like oc
if x(end,1)>.35
    disp('1');
else
    disp('0');

end

endfunction

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
	compartment_cytoplasm=3.2;
% Compartment: id = extracellular, name = extracellular, constant
	compartment_extracellular=1344.0;
% Compartment: id = nucleus, name = nucleus, constant

%dollar craft 1
compartment_nucleus=2.0693020752994533;

% Reaction: id = J1, name = TNFR transport into membrane	% Local Parameter:   id =  ka_1, name = TNFR transport into membrane ka

%dollar craft 2
reaction_J1_ka_1=0.002613627706524498;

	reaction_J1=reaction_J1_ka_1*x(4);

% Reaction: id = J2, name = TNFR production	% Local Parameter:
% id =  ka_2, name = TNFR production ka
%dollar craft 3
	reaction_J2_ka_2=2.700288380064102e-07;

	reaction_J2=reaction_J2_ka_2;

% Reaction: id = J3, name = TNFR degradation	% Local Parameter:   id =  ka_3, name = TNFR degradation ka
	reaction_J3_ka_3=5.6E-5;

	reaction_J3=reaction_J3_ka_3*x(1);

% Reaction: id = J4, name = RIP turnover	% Local Parameter:   id =  ka_4, name = RIP turnover ka

reaction_J4_ka_4=2.0256E-5;
	% Local Parameter:   id =  kd_4, name = RIP turnover kd
	reaction_J4_kd_4=1.0E-4;

	reaction_J4=reaction_J4_ka_4-reaction_J4_kd_4*x(5);

% Reaction: id = J5, name = TRADD turnover	% Local Parameter:   id =  ka_5, name = TRADD turnover ka
	reaction_J5_ka_5=2.9344E-5;
	% Local Parameter:   id =  kd_5, name = TRADD turnover kd
	reaction_J5_kd_5=1.0E-4;

	reaction_J5=reaction_J5_ka_5-reaction_J5_kd_5*x(6);

% Reaction: id = J6, name = TRAF2 turnover	% Local Parameter:   id =  ka_6, name = TRAF2 turnover ka
	reaction_J6_ka_6=3.3056E-5;
	% Local Parameter:   id =  kd_6, name = TRAF2 turnover kd
	reaction_J6_kd_6=1.0E-4;

	reaction_J6=reaction_J6_ka_6-reaction_J6_kd_6*x(7);

% Reaction: id = J7, name = FADD turnover	% Local Parameter:   id =  ka_7, name = FADD turnover ka
	reaction_J7_ka_7=3.0944E-5;
	% Local Parameter:   id =  kd_7, name = FADD turnover kd
	reaction_J7_kd_7=1.0E-4;

	reaction_J7=reaction_J7_ka_7-reaction_J7_kd_7*x(8);

% Reaction: id = J8, name = TNF~TNFR degradation	% Local Parameter:   id =  ka_8, name = TNF~TNFR degradation ka
	reaction_J8_ka_8=5.6E-5;

	reaction_J8=reaction_J8_ka_8*x(3);

% Reaction: id = J9, name = TNF:TNFR:TRADD degradation	% Local Parameter:   id =  ka_9, name = TNF:TNFR:TRADD degradation ka
	reaction_J9_ka_9=0.02352;

	reaction_J9=reaction_J9_ka_9*x(9);

% Reaction: id = J10, name = TNFR Complex1 degradation	% Local Parameter:   id =  ka_10, name = TNFR Complex1 degradation ka
	reaction_J10_ka_10=5.6E-5;

	reaction_J10=reaction_J10_ka_10*x(10);

% Reaction: id = J11, name = TNFR Complex2 degradation	% Local Parameter:   id =  ka_11, name = TNFR Complex2 degradation ka
	reaction_J11_ka_11=5.6E-5;

	reaction_J11=reaction_J11_ka_11*x(14);

% Reaction: id = J12, name = TNFR Complex2~FLIP degradation	% Local Parameter:   id =  ka_12, name = TNFR Complex2~FLIP degradation ka
	reaction_J12_ka_12=5.6E-5;

	reaction_J12=reaction_J12_ka_12*x(16);

% Reaction: id = J13, name = TNFR Complex2~FLIP~FLIP degradation	% Local Parameter:   id =  ka_13, name = TNFR Complex2~FLIP~FLIP degradation ka
	reaction_J13_ka_13=5.6E-5;

	reaction_J13=reaction_J13_ka_13*x(18);

% Reaction: id = J14, name = TNFR Complex2~Procaspase-8 degradation	% Local Parameter:   id =  ka_14, name = TNFR Complex2~Procaspase-8 degradation ka
	reaction_J14_ka_14=5.6E-5;

	reaction_J14=reaction_J14_ka_14*x(17);

% Reaction: id = J15, name = TNFR Complex2~Procaspase-8~Procaspase-8 degradation	% Local Parameter:   id =  ka_15, name = TNFR Complex2~Procaspase-8~Procaspase-8 degradation ka
	reaction_J15_ka_15=5.6E-5;

	reaction_J15=reaction_J15_ka_15*x(19);

% Reaction: id = J16, name = TNFR Complex2~FLIP~Procaspase-8 degradation	% Local Parameter:   id =  ka_16, name = TNFR Complex2~FLIP~Procaspase-8 degradation ka
	reaction_J16_ka_16=5.6E-5;

	reaction_J16=reaction_J16_ka_16*x(20);

% Reaction: id = J17, name = TNFR Complex2~FLIP~Procaspase-8~RIP~TRAF2 degradation	% Local Parameter:   id =  ka_17, name = TNFR Complex2~FLIP~Procaspase-8~RIP~TRAF2 degradation ka
	reaction_J17_ka_17=5.6E-5;

	reaction_J17=reaction_J17_ka_17*x(21);

% Reaction: id = J18, name = TNF~TNFR binding and release	% Local Parameter:   id =  ka_18, name = TNF~TNFR binding and release ka
	reaction_J18_ka_18=0.00953471;
	% Local Parameter:   id =  kd_18, name = TNF~TNFR binding and release kd
	reaction_J18_kd_18=6.60377E-5;

	reaction_J18=reaction_J18_ka_18*x(1)*x(2)-reaction_J18_kd_18*x(3);

% Reaction: id = J19, name = TNF~TNFR~TRADD building	% Local Parameter:   id =  ka_19, name = TNF~TNFR~TRADD building ka
	reaction_J19_ka_19=0.00427827;

	reaction_J19=reaction_J19_ka_19*x(3)*x(6);

% Reaction: id = J20, name = TNFR Complex1 building	% Local Parameter:   id =  ka_20, name = TNFR Complex1 building ka
	reaction_J20_ka_20=0.0976562;

	reaction_J20=reaction_J20_ka_20*x(5)*x(7)*x(9);

% Reaction: id = J21, name = Receptor internalisation step1	% Local Parameter:   id =  ka_21, name = Receptor internalisation step1 ka
	reaction_J21_ka_21=0.001135;

	reaction_J21=reaction_J21_ka_21*x(10);

% Reaction: id = J22, name = Receptor internalisation step2	% Local Parameter:   id =  ka_22, name = Receptor internalisation step2 ka
	reaction_J22_ka_22=0.001135;

	reaction_J22=reaction_J22_ka_22*x(11);

% Reaction: id = J23, name = Receptor internalisation step3	% Local Parameter:   id =  ka_23, name = Receptor internalisation step3 ka
	reaction_J23_ka_23=0.0118534;

	reaction_J23=reaction_J23_ka_23*x(8)^2*x(12);

% Reaction: id = J24, name = Receptor internalisation step4	% Local Parameter:   id =  ka_24, name = Receptor internalisation step4 ka
	reaction_J24_ka_24=0.1135;

	reaction_J24=reaction_J24_ka_24*x(13);

% Reaction: id = J25, name = FLIP recruitment to TNFR Complex2	% Local Parameter:   id =  ka_25, name = FLIP recruitment to TNFR Complex2 ka
	reaction_J25_ka_25=0.3125;

	reaction_J25=reaction_J25_ka_25*x(14)*x(15);

% Reaction: id = J26, name = FLIP recruitment to TNFR Complex2~FLIP	% Local Parameter:   id =  ka_26, name = FLIP recruitment to TNFR Complex2~FLIP ka
	reaction_J26_ka_26=0.3125;

	reaction_J26=reaction_J26_ka_26*x(15)*x(16);

% Reaction: id = J27, name = Procaspase-8 recruitment to TNFR Complex2	% Local Parameter:   id =  ka_27, name = Procaspase-8 recruitment to TNFR Complex2 ka
	reaction_J27_ka_27=0.03125;

	reaction_J27=reaction_J27_ka_27*x(14)*x(38);

% Reaction: id = J28, name = Procaspase-8 recruitment to TNFR Complex2~Procaspase-8	% Local Parameter:   id =  ka_28, name = Procaspase-8 recruitment to TNFR Complex2~Procaspase-8 ka
	reaction_J28_ka_28=0.03125;

	reaction_J28=reaction_J28_ka_28*x(17)*x(38);

% Reaction: id = J29, name = Caspase-8 activation by TNFR Complex2	% Local Parameter:   id =  ka_29, name = Caspase-8 activation by TNFR Complex2 ka
	reaction_J29_ka_29=0.45;

	reaction_J29=reaction_J29_ka_29*x(19);

% Reaction: id = J30, name = FLIP recruitment to TNFR Complex2~Procaspase-8	% Local Parameter:   id =  ka_30, name = FLIP recruitment to TNFR Complex2~Procaspase-8 ka
	reaction_J30_ka_30=0.3125;

	reaction_J30=reaction_J30_ka_30*x(15)*x(17);

% Reaction: id = J31, name = Procaspase-8 recruitment to TNFR Complex2~FLIP	% Local Parameter:   id =  ka_31, name = Procaspase-8 recruitment to TNFR Complex2~FLIP ka
	reaction_J31_ka_31=0.3125;

	reaction_J31=reaction_J31_ka_31*x(16)*x(38);

% Reaction: id = J32, name = Caspase-8 activation by TNFR Complex2~FLIP~Procaspase-8	% Local Parameter:   id =  ka_32, name = Caspase-8 activation by TNFR Complex2~FLIP~Procaspase-8 ka
	reaction_J32_ka_32=0.3;

	reaction_J32=reaction_J32_ka_32*x(20);

% Reaction: id = J33, name = RIP~TRAF2 recruitment at TNFR Complex2~FLIP~Procaspase-8	% Local Parameter:   id =  ka_33, name = RIP~TRAF2 recruitment at TNFR Complex2~FLIP~Procaspase-8 ka
	reaction_J33_ka_33=0.00976562;

	reaction_J33=reaction_J33_ka_33*x(5)*x(7)*x(20);

% Reaction: id = J34, name = IKK activation by TNFR Complex2~FLIP~Procaspase-8~RIP~TRAF2	% Local Parameter:   id =  ka_34, name = IKK activation by TNFR Complex2~FLIP~Procaspase-8~RIP~TRAF2 ka
	reaction_J34_ka_34=0.03125;

	reaction_J34=reaction_J34_ka_34*x(21)*x(22);

% Reaction: id = J35, name = IKK turnover	% Local Parameter:   id =  ka_35, name = IKK turnover ka
	reaction_J35_ka_35=6.4E-5;
	% Local Parameter:   id =  kd_35, name = IKK turnover kd
	reaction_J35_kd_35=1.0E-4;

	reaction_J35=reaction_J35_ka_35-reaction_J35_kd_35*x(22);

% Reaction: id = J36, name = NF-kappaB turnover	% Local Parameter:   id =  ka_36, name = NF-kappaB turnover ka
	reaction_J36_ka_36=1.6E-6;
	% Local Parameter:   id =  kd_36, name = NF-kappaB turnover kd
	reaction_J36_kd_36=1.0E-4;

	reaction_J36=reaction_J36_ka_36-reaction_J36_kd_36*x(25);

% Reaction: id = J37, name = FLIP turnover	% Local Parameter:   id =  ka_37, name = FLIP turnover ka
	reaction_J37_ka_37=2.24902E-6;
	% Local Parameter:   id =  kd_37, name = FLIP turnover kd
	reaction_J37_kd_37=1.0E-4;

	reaction_J37=reaction_J37_ka_37-reaction_J37_kd_37*x(15);

% Reaction: id = J38, name = XIAP turnover	% Local Parameter:   id =  ka_38, name = XIAP turnover ka
	reaction_J38_ka_38=7.72256E-4;
	% Local Parameter:   id =  kd_38, name = XIAP turnover kd
	reaction_J38_kd_38=1.0E-4;

	reaction_J38=reaction_J38_ka_38-reaction_J38_kd_38*x(37);

% Reaction: id = J39, name = A20 turnover	% Local Parameter:   id =  ka_39, name = A20 turnover ka
	reaction_J39_ka_39=9.6E-6;
	% Local Parameter:   id =  kd_39, name = A20 turnover kd
	reaction_J39_kd_39=1.0E-4;

	reaction_J39=reaction_J39_ka_39-reaction_J39_kd_39*x(24);

% Reaction: id = J40, name = IKK* degradation	% Local Parameter:   id =  ka_40, name = IKK* degradation ka
	reaction_J40_ka_40=1.0E-4;

	reaction_J40=reaction_J40_ka_40*x(23);

% Reaction: id = J41, name = IkappaBalpha~NF-kappaB complex degradation	% Local Parameter:   id =  ka_41, name = IkappaBalpha~NF-kappaB complex degradation ka
	reaction_J41_ka_41=1.0E-4;

	reaction_J41=reaction_J41_ka_41*x(27);

% Reaction: id = J42, name = nuclear NF-kappaB degradation	% Local Parameter:   id =  ka_42, name = nuclear NF-kappaB degradation ka
	reaction_J42_ka_42=1.0E-4;

	reaction_J42=reaction_J42_ka_42*x(29);

% Reaction: id = J43, name = IkappaBalpha-mRNA degradation	% Local Parameter:   id =  ka_43, name = IkappaBalpha-mRNA degradation ka
	reaction_J43_ka_43=3.94201E-4;

	reaction_J43=reaction_J43_ka_43*x(33);

% Reaction: id = J44, name = IkappaBalpha degradation	% Local Parameter:   id =  ka_44, name = IkappaBalpha degradation ka
	reaction_J44_ka_44=0.00154022;

	reaction_J44=reaction_J44_ka_44*x(26);

% Reaction: id = J45, name = free nuclear IkappaBalpha degradation	% Local Parameter:   id =  ka_45, name = free nuclear IkappaBalpha degradation ka
	reaction_J45_ka_45=1.0E-4;

	reaction_J45=reaction_J45_ka_45*x(30);

% Reaction: id = J46, name = nuclear IkappaBalpha~NF-kappaB complex degradation	% Local Parameter:   id =  ka_46, name = nuclear IkappaBalpha~NF-kappaB complex degradation ka
	reaction_J46_ka_46=1.0E-4;

	reaction_J46=reaction_J46_ka_46*x(31);

% Reaction: id = J47, name = P-IkappaBa degradation	% Local Parameter:   id =  ka_47, name = P-IkappaBa degradation ka
	reaction_J47_ka_47=0.0115517;

	reaction_J47=reaction_J47_ka_47*x(28);

% Reaction: id = J48, name = A20-mRNA degradation	% Local Parameter:   id =  ka_48, name = A20-mRNA degradation ka
	reaction_J48_ka_48=4.70498E-4;

	reaction_J48=reaction_J48_ka_48*x(32);

% Reaction: id = J49, name = XIAP-mRNA degradation	% Local Parameter:   id =  ka_49, name = XIAP-mRNA degradation ka
	reaction_J49_ka_49=1.04931E-4;

	reaction_J49=reaction_J49_ka_49*x(34);

% Reaction: id = J50, name = FLIP-mRNA degradation	% Local Parameter:   id =  ka_50, name = FLIP-mRNA degradation ka
	reaction_J50_ka_50=1.65744E-4;

	reaction_J50=reaction_J50_ka_50*x(35);

% Reaction: id = J51, name = IKK activation by TNFR Complex1	% Local Parameter:   id =  ka_51, name = IKK activation by TNFR Complex1 ka
	reaction_J51_ka_51=93.75;

	reaction_J51=reaction_J51_ka_51*x(10)*x(22);

% Reaction: id = J52, name = IKK* inactivation	% Local Parameter:   id =  ka_52, name = IKK* inactivation ka
	reaction_J52_ka_52=0.1;

	reaction_J52=reaction_J52_ka_52*x(23);

% Reaction: id = J53, name = TNFR Complex1 inactivation by A20	% Local Parameter:   id =  ka_53, name = TNFR Complex1 inactivation by A20 ka
	reaction_J53_ka_53=0.00625;

	reaction_J53=reaction_J53_ka_53*x(10)*x(24);

% Reaction: id = J54, name = IkappaBalpha NF-kappaB association	% Local Parameter:   id =  ka_54, name = IkappaBalpha NF-kappaB association ka
	reaction_J54_ka_54=1.25;

	reaction_J54=reaction_J54_ka_54*x(25)*x(26);

% Reaction: id = J55, name = release and degradation of bound IkappaBalpha	% Local Parameter:   id =  ka_55, name = release and degradation of bound IkappaBalpha ka
	reaction_J55_ka_55=0.104167;

	reaction_J55=reaction_J55_ka_55*x(23)*x(27);

% Reaction: id = J56, name = NF-kappaB nuclear translocation	% Local Parameter:   id =  ka_56, name = NF-kappaB nuclear translocation ka
	reaction_J56_ka_56=0.0125;

	reaction_J56=reaction_J56_ka_56*x(25);

% Reaction: id = J57, name = IkappaBalpha-mRNA transcription	% Local Parameter:   id =  ka_57, name = IkappaBalpha-mRNA transcription ka
	reaction_J57_ka_57=3.0303E-5;

	reaction_J57=reaction_J57_ka_57*x(29);

% Reaction: id = J58, name = IkappaBalpha translation	% Local Parameter:   id =  ka_58, name = IkappaBalpha translation ka
	reaction_J58_ka_58=0.0606061;

	reaction_J58=reaction_J58_ka_58*x(33);

% Reaction: id = J59, name = IkappaBalpha nuclear translocation	% Local Parameter:   id =  ka_59, name = IkappaBalpha nuclear translocation ka
	reaction_J59_ka_59=0.005;
	% Local Parameter:   id =  kd_59, name = IkappaBalpha nuclear translocation kd
	reaction_J59_kd_59=0.00257576;

	reaction_J59=reaction_J59_ka_59*x(26)-reaction_J59_kd_59*x(30);

% Reaction: id = J60, name = IkappaBalpha binding NF-kappaB in nucleus	% Local Parameter:   id =  ka_60, name = IkappaBalpha binding NF-kappaB in nucleus ka
	reaction_J60_ka_60=1.4348;

	reaction_J60=reaction_J60_ka_60*x(29)*x(30);

% Reaction: id = J61, name = IkappaBalpha_NF-kappaB N-C export	% Local Parameter:   id =  ka_61, name = IkappaBalpha_NF-kappaB N-C export ka
	reaction_J61_ka_61=0.0151515;

	reaction_J61=reaction_J61_ka_61*x(31);

% Reaction: id = J62, name = A20-mRNA transcription	% Local Parameter:   id =  ka_62, name = A20-mRNA transcription ka
	reaction_J62_ka_62=3.78788E-5;

	reaction_J62=reaction_J62_ka_62*x(29);

% Reaction: id = J63, name = A20 translation	% Local Parameter:   id =  ka_63, name = A20 translation ka
	reaction_J63_ka_63=0.0151515;

	reaction_J63=reaction_J63_ka_63*x(32);

% Reaction: id = J64, name = XIAP-mRNA transcription	% Local Parameter:   id =  ka_64, name = XIAP-mRNA transcription ka
	reaction_J64_ka_64=3.33333E-5;

	reaction_J64=reaction_J64_ka_64*x(29);

% Reaction: id = J65, name = XIAP translation	% Local Parameter:   id =  ka_65, name = XIAP translation ka
	reaction_J65_ka_65=0.0506061;

	reaction_J65=reaction_J65_ka_65*x(34);

% Reaction: id = J66, name = FLIP-mRNA transcription	% Local Parameter:   id =  ka_66, name = FLIP-mRNA transcription ka
	reaction_J66_ka_66=3.33333E-5;

	reaction_J66=reaction_J66_ka_66*x(29);

% Reaction: id = J67, name = FLIP translation	% Local Parameter:   id =  ka_67, name = FLIP translation ka
	reaction_J67_ka_67=0.00687273;

	reaction_J67=reaction_J67_ka_67*x(35);

% Reaction: id = J68, name = Procaspase-8 turnover	% Local Parameter:   id =  ka_68, name = Procaspase-8 turnover ka
	reaction_J68_ka_68=1.97531E-4;
	% Local Parameter:   id =  kd_68, name = Procaspase-8 turnover kd
	reaction_J68_kd_68=6.17284E-5;

	reaction_J68=reaction_J68_ka_68-reaction_J68_kd_68*x(38);

% Reaction: id = J69, name = Procaspase-3 turnover	% Local Parameter:   id =  ka_69, name = Procaspase-3 turnover ka
	reaction_J69_ka_69=4.93827E-5;
	% Local Parameter:   id =  kd_69, name = Procaspase-3 turnover kd
	reaction_J69_kd_69=6.17284E-5;

	reaction_J69=reaction_J69_ka_69-reaction_J69_kd_69*x(39);

% Reaction: id = J70, name = Procaspase-6 turnover	% Local Parameter:   id =  ka_70, name = Procaspase-6 turnover ka
	reaction_J70_ka_70=3.95062E-6;
	% Local Parameter:   id =  kd_70, name = Procaspase-6 turnover kd
	reaction_J70_kd_70=6.17284E-5;

	reaction_J70=reaction_J70_ka_70-reaction_J70_kd_70*x(40);

% Reaction: id = J71, name = Caspase-8 degradation	% Local Parameter:   id =  ka_71, name = Caspase-8 degradation ka
	reaction_J71_ka_71=5.78704E-5;

	reaction_J71=reaction_J71_ka_71*x(41);

% Reaction: id = J72, name = Caspase-3 degradation	% Local Parameter:   id =  ka_72, name = Caspase-3 degradation ka
	reaction_J72_ka_72=5.78704E-5;

	reaction_J72=reaction_J72_ka_72*x(42);

% Reaction: id = J73, name = Caspase-6 degradation	% Local Parameter:   id =  ka_73, name = Caspase-6 degradation ka
	reaction_J73_ka_73=5.78704E-5;

	reaction_J73=reaction_J73_ka_73*x(43);

% Reaction: id = J74, name = XIAP~Caspase-3 complex degradation	% Local Parameter:   id =  ka_74, name = XIAP~Caspase-3 complex degradation ka
	reaction_J74_ka_74=5.78704E-5;

	reaction_J74=reaction_J74_ka_74*x(45);

% Reaction: id = J75, name = BAR turnover	% Local Parameter:   id =  ka_75, name = BAR turnover ka
	reaction_J75_ka_75=1.66603E-6;
	% Local Parameter:   id =  kd_75, name = BAR turnover kd
	reaction_J75_kd_75=5.78704E-6;

	reaction_J75=reaction_J75_ka_75-reaction_J75_kd_75*x(36);

% Reaction: id = J76, name = BAR~Caspase-8 complex degradation	% Local Parameter:   id =  ka_76, name = BAR~Caspase-8 complex degradation ka
	reaction_J76_ka_76=5.78704E-5;

	reaction_J76=reaction_J76_ka_76*x(44);

% Reaction: id = J77, name = PARP turnover	% Local Parameter:   id =  ka_77, name = PARP turnover ka
	reaction_J77_ka_77=5.78704E-6;
	% Local Parameter:   id =  kd_77, name = PARP turnover kd
	reaction_J77_kd_77=9.64506E-6;

	reaction_J77=reaction_J77_ka_77*x(46)-reaction_J77_kd_77;

% Reaction: id = J78, name = CPARP degradation	% Local Parameter:   id =  ka_78, name = CPARP degradation ka
	reaction_J78_ka_78=5.78704E-6;

	reaction_J78=reaction_J78_ka_78*x(47);

% Reaction: id = J79, name = Caspase-3 activation	% Local Parameter:   id =  ka_79, name = Caspase-3 activation ka
	reaction_J79_ka_79=0.015625;

	reaction_J79=reaction_J79_ka_79*x(39)*x(41);

% Reaction: id = J80, name = Caspase-6 activation	% Local Parameter:   id =  ka_80, name = Caspase-6 activation ka
	reaction_J80_ka_80=0.009375;

	reaction_J80=reaction_J80_ka_80*x(40)*x(42);

% Reaction: id = J81, name = Caspase-8 activation	% Local Parameter:   id =  ka_81, name = Caspase-8 activation ka
	reaction_J81_ka_81=0.0015625;

	reaction_J81=reaction_J81_ka_81*x(38)*x(43);

% Reaction: id = J82, name = XIAP~Caspase-3 complex formation	% Local Parameter:   id =  ka_82, name = XIAP~Caspase-3 complex formation ka
	reaction_J82_ka_82=0.625;
	% Local Parameter:   id =  kd_82, name = XIAP~Caspase-3 complex formation kd
	reaction_J82_kd_82=0.001;

	reaction_J82=reaction_J82_ka_82*x(37)*x(42)-reaction_J82_kd_82*x(45);

% Reaction: id = J83, name = XIAP degradation due to Caspase-3	% Local Parameter:   id =  ka_83, name = XIAP degradation due to Caspase-3 ka
	reaction_J83_ka_83=1.875;

	reaction_J83=reaction_J83_ka_83*x(37)*x(42);

% Reaction: id = J84, name = XIAP~Caspase-3 complex breakup	% Local Parameter:   id =  ka_84, name = XIAP~Caspase-3 complex breakup ka
	reaction_J84_ka_84=5.0E-5;

	reaction_J84=reaction_J84_ka_84*x(45);

% Reaction: id = J85, name = negative feedback loop Caspase-3 on TNFR Complex1	% Local Parameter:   id =  ka_85, name = negative feedback loop Caspase-3 on TNFR Complex1 ka
	reaction_J85_ka_85=0.15625;

	reaction_J85=reaction_J85_ka_85*x(5)*x(42);

% Reaction: id = J86, name = FLIP degradation by Caspase-3	% Local Parameter:   id =  ka_86, name = FLIP degradation by Caspase-3 ka
	reaction_J86_ka_86=0.15625;

	reaction_J86=reaction_J86_ka_86*x(15)*x(42);

% Reaction: id = J87, name = PARP cleavage as Casp3 substrate	% Local Parameter:   id =  ka_87, name = PARP cleavage as Casp3 substrate ka
	reaction_J87_ka_87=0.1875;

	reaction_J87=reaction_J87_ka_87*x(42)*x(46);

% Reaction: id = J88, name = BAR~Caspase-8 complex formation	% Local Parameter:   id =  ka_88, name = BAR~Caspase-8 complex formation ka
	reaction_J88_ka_88=0.520833;
	% Local Parameter:   id =  kd_88, name = BAR~Caspase-8 complex formation kd
	reaction_J88_kd_88=0.001;

	reaction_J88=reaction_J88_ka_88*x(36)*x(41)-reaction_J88_kd_88*x(44);

	xdot=zeros(47,1);
	
% Species:   id = TNFR_E, name = TNFR_E, affected by kineticLaw
	xdot(1) = ( 1.0 * reaction_J1) + (-1.0 * reaction_J3) + (-1.0 * reaction_J18);
	
% Species:   id = TNF_E, name = TNF_E, affected by kineticLaw
	xdot(2) = (-1.0 * reaction_J18);
	
% Species:   id = TNF_TNFR_E, name = TNF:TNFR_E, affected by kineticLaw
	xdot(3) = (-1.0 * reaction_J8) + ( 1.0 * reaction_J18) + (-1.0 * reaction_J19);
	
% Species:   id = TNFR, name = TNFR, affected by kineticLaw
	xdot(4) = (-1.0 * reaction_J1) + ( 1.0 * reaction_J2);
	
% Species:   id = RIP, name = RIP, affected by kineticLaw
	xdot(5) = ( 1.0 * reaction_J4) + (-1.0 * reaction_J20) + ( 1.0 * reaction_J22) + (-1.0 * reaction_J33) + (-1.0 * reaction_J85);
	
% Species:   id = TRADD, name = TRADD, affected by kineticLaw
	xdot(6) = ( 1.0 * reaction_J5) + (-1.0 * reaction_J19);
	
% Species:   id = TRAF2, name = TRAF2, affected by kineticLaw
	xdot(7) = ( 1.0 * reaction_J6) + (-1.0 * reaction_J20) + ( 1.0 * reaction_J22) + (-1.0 * reaction_J33) + ( 1.0 * reaction_J53);
	
% Species:   id = FADD, name = FADD, affected by kineticLaw
	xdot(8) = ( 1.0 * reaction_J7) + (-2.0 * reaction_J23);
	
% Species:   id = TNF_TNFR_TRADD, name = TNF:TNFR:TRADD, affected by kineticLaw
	xdot(9) = (-1.0 * reaction_J9) + ( 1.0 * reaction_J19) + (-1.0 * reaction_J20) + ( 1.0 * reaction_J53);
	
% Species:   id = TNFRC1, name = TNFRC1, affected by kineticLaw
	xdot(10) = (-1.0 * reaction_J10) + ( 1.0 * reaction_J20) + (-1.0 * reaction_J21) + (-1.0 * reaction_J53);
	
% Species:   id = TNFRCint1, name = TNFRCint1, affected by kineticLaw
	xdot(11) = ( 1.0 * reaction_J21) + (-1.0 * reaction_J22);
	
% Species:   id = TNFRCint2, name = TNFRCint2, affected by kineticLaw
	xdot(12) = ( 1.0 * reaction_J22) + (-1.0 * reaction_J23);
	
% Species:   id = TNFRCint3, name = TNFRCint3, affected by kineticLaw
	xdot(13) = ( 1.0 * reaction_J23) + (-1.0 * reaction_J24);
	
% Species:   id = TNFRC2, name = TNFRC2, affected by kineticLaw
	xdot(14) = (-1.0 * reaction_J11) + ( 1.0 * reaction_J24) + (-1.0 * reaction_J25) + (-1.0 * reaction_J27) + ( 1.0 * reaction_J29) + ( 1.0 * reaction_J32);
	
% Species:   id = FLIP, name = FLIP, affected by kineticLaw
	xdot(15) = (-1.0 * reaction_J25) + (-1.0 * reaction_J26) + (-1.0 * reaction_J30) + ( 1.0 * reaction_J37) + ( 1.0 * reaction_J67) + (-1.0 * reaction_J86);
	
% Species:   id = TNFRC2_FLIP, name = TNFRC2:FLIP, affected by kineticLaw
	xdot(16) = (-1.0 * reaction_J12) + ( 1.0 * reaction_J25) + (-1.0 * reaction_J26) + (-1.0 * reaction_J31);
	
% Species:   id = TNFRC2_pCasp8, name = TNFRC2:pCasp8, affected by kineticLaw
	xdot(17) = (-1.0 * reaction_J14) + ( 1.0 * reaction_J27) + (-1.0 * reaction_J28) + (-1.0 * reaction_J30);
	
% Species:   id = TNFRC2_FLIP_FLIP, name = TNFRC2:FLIP:FLIP, affected by kineticLaw
	xdot(18) = (-1.0 * reaction_J13) + ( 1.0 * reaction_J26);
	
% Species:   id = TNFRC2_pCasp8_pCasp8, name = TNFRC2:pCasp8:pCasp8, affected by kineticLaw
	xdot(19) = (-1.0 * reaction_J15) + ( 1.0 * reaction_J28) + (-1.0 * reaction_J29);
	
% Species:   id = TNFRC2_FLIP_pCasp8, name = TNFRC2:FLIP:pCasp8, affected by kineticLaw
	xdot(20) = (-1.0 * reaction_J16) + ( 1.0 * reaction_J30) + ( 1.0 * reaction_J31) + (-1.0 * reaction_J32) + (-1.0 * reaction_J33);
	
% Species:   id = TNFRC2_FLIP_pCasp8_RIP_TRAF2, name = TNFRC2:FLIP:pCasp8:RIP:TRAF2, affected by kineticLaw
	xdot(21) = (-1.0 * reaction_J17) + ( 1.0 * reaction_J33);
	
% Species:   id = IKK, name = IKK, affected by kineticLaw
	xdot(22) = (-1.0 * reaction_J34) + ( 1.0 * reaction_J35) + (-1.0 * reaction_J51) + ( 1.0 * reaction_J52);
	
% Species:   id = IKKa, name = IKKa, affected by kineticLaw
	xdot(23) = ( 1.0 * reaction_J34) + (-1.0 * reaction_J40) + ( 1.0 * reaction_J51) + (-1.0 * reaction_J52);
	
% Species:   id = A20, name = A20, affected by kineticLaw
	xdot(24) = ( 1.0 * reaction_J39) + ( 1.0 * reaction_J63);
	
% Species:   id = NFkB, name = NFkB, affected by kineticLaw
	xdot(25) = ( 1.0 * reaction_J36) + (-1.0 * reaction_J54) + ( 1.0 * reaction_J55) + (-1.0 * reaction_J56);
	
% Species:   id = IkBa, name = IkBa, affected by kineticLaw
	xdot(26) = (-1.0 * reaction_J44) + (-1.0 * reaction_J54) + ( 1.0 * reaction_J58) + (-1.0 * reaction_J59);
	
% Species:   id = IkBa_NFkB, name = IkBa:NFkB, affected by kineticLaw
	xdot(27) = (-1.0 * reaction_J41) + ( 1.0 * reaction_J54) + (-1.0 * reaction_J55) + ( 1.0 * reaction_J61);
	
% Species:   id = PIkBa, name = PIkBa, affected by kineticLaw
	xdot(28) = (-1.0 * reaction_J47) + ( 1.0 * reaction_J55);
	
% Species:   id = NFkB_N, name = NFkB_N, affected by kineticLaw
	xdot(29) = (-1.0 * reaction_J42) + ( 1.0 * reaction_J56) + (-1.0 * reaction_J60);
	
% Species:   id = IkBa_N, name = IkBa_N, affected by kineticLaw
	xdot(30) = (-1.0 * reaction_J45) + ( 1.0 * reaction_J59) + (-1.0 * reaction_J60);
	
% Species:   id = IkBa_NFkB_N, name = IkBa:NFkB_N, affected by kineticLaw
	xdot(31) = (-1.0 * reaction_J46) + ( 1.0 * reaction_J60) + (-1.0 * reaction_J61);
	
% Species:   id = A20_mRNA, name = A20_mRNA, affected by kineticLaw
	xdot(32) = (-1.0 * reaction_J48) + ( 1.0 * reaction_J62);
	
% Species:   id = IkBa_mRNA, name = IkBa_mRNA, affected by kineticLaw
	xdot(33) = (-1.0 * reaction_J43) + ( 1.0 * reaction_J57);
	
% Species:   id = XIAP_mRNA, name = XIAP_mRNA, affected by kineticLaw
	xdot(34) = (-1.0 * reaction_J49) + ( 1.0 * reaction_J64);
	
% Species:   id = FLIP_mRNA, name = FLIP_mRNA, affected by kineticLaw
	xdot(35) = (-1.0 * reaction_J50) + ( 1.0 * reaction_J66);
	
% Species:   id = BAR, name = BAR, affected by kineticLaw
	xdot(36) = ( 1.0 * reaction_J75) + (-1.0 * reaction_J88);
	
% Species:   id = XIAP, name = XIAP, affected by kineticLaw
	xdot(37) = ( 1.0 * reaction_J38) + ( 1.0 * reaction_J65) + (-1.0 * reaction_J82) + (-1.0 * reaction_J83) + ( 1.0 * reaction_J84);
	
% Species:   id = pCasp8, name = pCasp8, affected by kineticLaw
	xdot(38) = (-1.0 * reaction_J27) + (-1.0 * reaction_J28) + (-1.0 * reaction_J31) + ( 1.0 * reaction_J68) + (-1.0 * reaction_J81);
	
% Species:   id = pCasp3, name = pCasp3, affected by kineticLaw
	xdot(39) = ( 1.0 * reaction_J69) + (-1.0 * reaction_J79);
	
% Species:   id = pCasp6, name = pCasp6, affected by kineticLaw
	xdot(40) = ( 1.0 * reaction_J70) + (-1.0 * reaction_J80);
	
% Species:   id = Casp8, name = Casp8, affected by kineticLaw
	xdot(41) = ( 1.0 * reaction_J29) + ( 1.0 * reaction_J32) + (-1.0 * reaction_J71) + ( 1.0 * reaction_J81) + (-1.0 * reaction_J88);
	
% Species:   id = Casp3, name = Casp3, affected by kineticLaw
	xdot(42) = (-1.0 * reaction_J72) + ( 1.0 * reaction_J79) + (-1.0 * reaction_J82);
	
% Species:   id = Casp6, name = Casp6, affected by kineticLaw
	xdot(43) = (-1.0 * reaction_J73) + ( 1.0 * reaction_J80);
	
% Species:   id = BAR_Casp8, name = BAR:Casp8, affected by kineticLaw
	xdot(44) = (-1.0 * reaction_J76) + ( 1.0 * reaction_J88);
	
% Species:   id = XIAP_Casp3, name = XIAP:Casp3, affected by kineticLaw
	xdot(45) = (-1.0 * reaction_J74) + ( 1.0 * reaction_J82) + (-1.0 * reaction_J84);
	
% Species:   id = PARP, name = PARP, affected by kineticLaw
	xdot(46) = (-1.0 * reaction_J77) + (-1 * reaction_J87);

        %dollar craft 4 : discrete example:by this syntax I mean
        %any number in the list [] will be chosen with equal likelihood
        craftDiscreteVar = 1.0;
	
% Species:   id = cPARP, name = cPARP, affected by kineticLaw
	xdot(47) = (-1.0 * reaction_J78) + ( craftDiscreteVar* reaction_J87);
endfunction

% adding few functions representing operators used in SBML but not present directly 
% in either matlab or octave. 


