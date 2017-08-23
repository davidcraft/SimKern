function v2a()
% set plt = true to plot the graph
plt = true;
	%this is the master sim0 version 1.0

	%note for octave compatibility, must install odepkg for octave and also execute the following line
	%every session. 
	%  pkg load odepkg
	%Alternately, make a file called .octaverc in your home directory, and put that line in the file.
	%we'll have to verify that this works when calling octave through python.

	
	%ENTITIES in the model:
	%These are the proteins, mRNA, etc., each of which has an ODE describing its dynamics, which we store in a file
	%so we can re-use in the ODE function.
	variableDefinition2a

	
	%Initial conditions
	x0 = zeros(numEntities,1);
	%here any non-zero initial conditions
	%for now, we we are modeling our radiation blast as an exponetially decaying level, we just initialize
	%the radiation compartment.
	x0(O_RADIATION) = 1;


	%Simulation time span. We will take the units of time to be MINUTES since that is what Elias paper uses. 

        numDays=1;
	Tend_minutes = 24*60*numDays; %minutes 
	tspan=[0,Tend_minutes];

	%Just using these default values. They seem fine for now, we might find it useful to adjust later. I'm also using the
	%low order solver ode23. We may need to change this later too.
	opts = odeset('AbsTol',1e-3,'RelTol',1e-5,'MaxStep',6,'InitialStep',.1);
	[t,x]=ode23(@f,tspan,x0,opts);
    if plt == true
        subplot(1,2,1)
        varsToPlot = [2 5 6];
        plot(t,x(:,varsToPlot));
        legend(N(varsToPlot));

        %here replicate stuff plotted in Elias figure 4.8
        subplot(1,2,2)
%       varsToPlot = [P_ATMPhos P_P53Phos P_MDM2 P_WIP1];
        varsToPlot = [P_ATMPhos P_P53Phos P_MDM2 P_WIP1 ...
            O_ARRESTSIGNAL P_ECDK2 P_p21cip];
        h=plot(t,x(:,varsToPlot));
        set(h(1),'color', 'r');
        set(h(2),'color', 'g');
        set(h(3),'color', 'b');
        set(h(4),'color', 'k');
        legend(N(varsToPlot));
    end
	
	function xd=f(t,x)

		%In this function we have the differential equations.

		%I'm hoping calling this script at every entrance to this function won't slow things
		%down too much. I don't think it will. If it does we might consider using globals or something like that.

		variableDefinition2a
		
		%We start with all the parameters of those equations. We might want to think a little more
		%about an organized nomenclature for these. For example it would be nice to be able to tell from the name
		%basically what it is doing. But we also don't want to be cumbersome and have really long names (I think..).
		%So for now we will go with this but we might come up with a more refined standard.
		c_Kiri = .03;
		c_Kbe = .03;
		c_Kbec = .01;
		c_Kc = .02;
		c_Kcc = .01; %caps clearance rate/halflife term
		c_Mc = .01;
		c_Kcer = .01;
		c_Kf = .01;

		%next come constants from the Elias paper https://hal.inria.fr/hal-00822308/document
		ATMtot = 1.3; % total concentration of ATM proteins (monomers and dimers)
		%E = 2.5e-5; % signal produced by DNA damage [orig Elias model, I
		%their E in the paper was anything from  2.5e-5 to 10. can use the parameter Kph2 to do this scaling.

		%do it differently]
		% the system's constants, for the full description see Table B.1

		%TODO - find these rate constant values from paper supplementary
		%info 
		k3=3; 
		Katm=0.1;
		kdph1=78; 
		Kdph1=25;
		k1=10; 
		K1=1.01;
		pp=0.083;
		Vr=10;
		pm=0.04; 
		delta_m=0.16; 
		kSm=0.005; 
		kSpm=1; 
		KSpm=0.1; 
		pmrna=0.083;
		delta_mrna=0.0001; 
		ktm=1;
		kS=0.015; 
		delta_p=0.2;
		pw=0.083; 
		delta_w=0.2; 
		kSw=0.03; 
		kSpw=1; 
		KSpw=0.1; 
		pwrna=0.083;
		delta_wrna=0.001; 
		ktw=1;
		% this next one to modify the radiation impact:
		kph2=15;
		Kph2=1;
		
		kdph2=96; 
		Kdph2=26;
		% nondimensionalisation of the variables is done so that the term relative to
		% the main bifurcation parameter E depends on as small possible number of
		% parameters as possible. Other choices are, of course, possible.
		%barE = E/Kph2;
		ts=1/kph2;
		alpha1=Katm; alpha4=alpha1; alpha2=kSpm/k3; alpha3=alpha2;
		alphav1=Kph2; alphav2=alphav1;
		alphaw1=kSpw/k3*10; alphaw2=alphaw1;
		barkdph1 = ts*kdph1*(alphaw1/alpha1); barKdph1 = Kdph1/alpha4;
		bark1 = ts*k1*(alpha2/alpha1); barK1 = K1/alpha1;

		bark3 = ts*k3*(alphav2/alpha1); barKatm = Katm/alpha1;
		barpp=ts*pp; barpm=ts*pm; bardeltam=ts*delta_m;
		barkSm=ts*kSm/alpha3; barkSpm=ts*kSpm/alpha3; barKSpm=KSpm/alpha4;
		barpmrna=ts*pmrna; bardeltamrna=ts*delta_mrna;
		barpw=ts*pw; bardeltaw=ts*delta_w;
		barkSw=ts*kSw/alphaw2; barkSpw=ts*kSpw/alphaw2; barKSpw=KSpw/alpha4;
		barpwrna=ts*pwrna; bardeltawrna=ts*delta_wrna;
		barkdph2=ts*kdph2*(alphaw1/alphav2); barKdph2=Kdph2/(alphav2^2);
		barkS=ts*kS/alpha1; bardeltap=ts*delta_p;
		barktm=ts*ktm; barktw=ts*ktw;
		ATMtot=ATMtot/alphav1;
        
        %Apoptosis Rate Constants --> p53 to Cyt c model
        c_KpB1 = 1;
        c_KpB2 = 1;
        c_KpB3 = 1;
        c_KpBX1 = 1;
        c_KpBX2 = 1;
        c_KpBX3 = 1;
        c_KpF1 = 1;
        c_KpF2 = 1;
        c_KpF3 = 1;
        c_KpBa1 = 1;
        c_KpBa2 = 1;
        c_KpBa3 = 1;
        c_KBaxC = 1;
        c_KBcl2C = 1;
        c_KBclXC = 1;
        c_KCyt = 1;
        c_KAA = 1;
        c_KAA2 = 1;
        c_KApop = 1;
        c_KApop2 = 1;
        c_KApop3 = 1;
        c_Kpp1 = 1;
        c_Kpp2 = 1;
        c_Kpp3 = 1;
        c_KpE1 = 1;
        c_KpE2 = 1;
        c_KpE3 = 1;
        c_KE = 1;
        KRb = 1; 
        c_Ka1 = 1;
        c_Ka2 = 1;
        Kg = 1;
		
		xd = zeros(numEntities,1);
		
		% the odes

		%DNA impact and repair kinetics
		xd(O_RADIATION) = -c_Kiri * x(O_RADIATION);
		xd(O_BROKEN_ENDS) = c_Kbe * x(O_RADIATION) - c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS);
		xd(O_CAPS) = min((c_Kc * x(O_BROKEN_ENDS)) ,c_Mc) - c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS) ...
							 - c_Kcc * x(O_CAPS);
		xd(O_CAPPED_ENDS) = c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS) -c_Kcer * x(O_CAPPED_ENDS);
		xd(O_CAPPED_ENDS_READY) = c_Kcer * x(O_CAPPED_ENDS) - c_Kf * x(O_CAPPED_ENDS_READY);
		xd(O_FIXED) = c_Kf * x(O_CAPPED_ENDS_READY);

		%Elias paper https://hal.inria.fr/hal-00822308/document
		% equations for single compartment model (C.1)
		% p53
		xd(P_P53) = barkS + barkdph1 * x(P_WIP1) * ((x(P_P53Phos)/(barKdph1+x(P_P53Phos)))) ...
            - bark1 * x(P_MDM2) * (x(P_P53)/(barK1+x(P_P53))) ...
					-bark3 * x(P_ATMPhos) * (x(P_P53)/(barKatm+x(P_P53))) - delta_p*(x(P_P53));
		% Mdm2
		xd(P_MDM2) = barktm * x(M_MDM2) - x(P_MDM2);
		% Mdm2 mRNA
		xd(M_MDM2) = barkSm + barkSpm * (x(P_P53Phos)^4/(barKSpm^4+x(P_P53Phos)^4)) - delta_mrna * x(M_MDM2) ...
					- barktm * x(M_MDM2);
		% p53_p
		xd(P_P53Phos) = bark3 * x(P_ATMPhos) * (x(P_P53)/(barKatm+x(P_P53))) - barkdph1*x(P_WIP1)*(x(P_P53Phos)/(barKdph1+x(P_P53Phos)));
		%Wip1
		xd(P_WIP1) = barktw * x(M_WIP1) - delta_w * x(P_WIP1); 
		%Wip1 mRNA
		xd(M_WIP1) = barkSw + barkSpw * (x(P_P53Phos)^4/(barKSpw^4+x(P_P53Phos)^4)) - delta_wrna * x(M_WIP1) ...
					- barktw * x(M_WIP1);
		% Atm_p
		%here we are replacing their E with "broken ends": assuming
		%"danger signal" is proportional to number of broken ends:
		%xd(P_ATMPhos)=2*Kph2*0.1*( ((ATMtot-x(P_ATMPhos))/2)/(1+((ATMtot-x(P_ATMPhos))/2) )) -2*barkdph2*x(P_WIP1)*(x(P_ATMPhos)^2/(barKdph2+x(P_ATMPhos)^2));
		xd(P_ATMPhos) = 2*Kph2 * x(O_BROKEN_ENDS) * ((ATMtot- x(P_ATMPhos))/2)/(barKdph2 + ((ATMtot - x(P_ATMPhos))/2)) ...
            -2*barkdph2 * x(P_WIP1) * (x(P_ATMPhos)^2/(barKdph2 + x(P_ATMPhos)^2));
		
        
        %Apoptosis --> p53 to Cytochrome c
        %and apoptosome
        %BCl-2
        xd(P_Bcl2) = c_KpB1*(x(P_P53Phos)^4)/(c_KpB2 + x(P_P53Phos)^4) - c_KpB3 * x(P_Bcl2);
        %Bcl-Xl
        xd(P_BclXl) = c_KpBX1*(x(P_P53Phos)^4)/(c_KpBX2 + x(P_P53Phos)^4) - c_KpBX3 * x(P_BclXl);
        %Fas-l
        xd(P_FasL) = c_KpF1*(x(P_P53Phos)^4)/(c_KpF2 + x(P_P53Phos)^4) - c_KpF3 * x(P_FasL);
        %BAX
        xd(P_Bax) = c_KpBa1*(x(P_P53Phos)^4)/(c_KpBa2 + x(P_P53Phos)^4) - c_KpBa3 * x(P_Bax);
        %Cytochrome c
        xd(P_CytC) = c_KBaxC*(x(P_Bax)) - c_KBcl2C*(x(P_Bcl2)) - c_KBclXC*(x(P_BclXl)) - c_KCyt*(x(P_CytC)) ...
            - c_KAA*x(P_Apoptosome)*x(P_CytC)^7;
        %Apoptosome
        xd(P_Apoptosome) = c_KAA*x(P_Apoptosome)*x(P_CytC)^7 - c_KAA2 *x(P_Apoptosome);
        %Apoptosis
        xd(P_Apoptosis) = c_KApop*x(P_FasL) + c_KApop2 * x(P_Apoptosome) - c_KApop3 * x(P_Apoptosis);
        
        %Apoptosis --> p53 to pRb via ECDK2
        %p21cip
        xd(P_p21cip) = c_Kpp1*(x(P_P53Phos)^4)/(c_Kpp2 + x(P_P53Phos)^4) - c_Kpp3 * x(P_p21cip);
        %ECDK2
        xd(P_ECDK2) = c_KpE1 - c_KpE2*x(P_p21cip)/(c_KpE3 + x(P_p21cip)) - c_KE * x(P_ECDK2);
        %Cell Cycle Arrest, Note: kRb should either be on or off (represents gene)
        %Note: Krb should have negative sign in front but will produce negative graphs, thus made positive
        %Double check this later
        xd(O_ARRESTSIGNAL) = (-KRb*c_Ka1*xd(P_ECDK2)*exp(-c_Ka1*(x(P_ECDK2)- c_Ka2)))/ ...
            (1+ exp(-c_Ka1*(x(P_ECDK2)- c_Ka2)))^2;
        %Cell Cycling, Note: Kg represents growth constant
        xd(O_CELLCYCLING) = Kg*(1 - xd(O_ARRESTSIGNAL)); %Note - Increases indefinitely
        
        
        



		
