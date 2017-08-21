function v2()
% set plt = true to plot the graph
	%this is the master sim0 version 1.0

	%note for octave compatibility, must install odepkg for octave and also execute the following line
	%every session.
	%  pkg load odepkg
	%Alternately, make a file called .octaverc in your home directory, and put that line in the file.
	%we'll have to verify that this works when calling octave through python.


	%ENTITIES in the model:
	%These are the proteins, mRNA, etc., each of which has an ODE describing its dynamics, which we store in a file
	%so we can re-use in the ODE function.
	variableDefinition2

	plt = true;
	%Initial conditions
	x0 = zeros(numEntities, 1);
	%here any non-zero initial conditions
	%for now, we we are modeling our radiation blast as an exponetially decaying level, we just initialize
	%the radiation compartment.
	x0(O_CELLCYCLING) = 1;
	x0(P_ECDK2) = 1;
	x0(O_RADIATION) = 1;


	%Simulation time span. We will take the units of time to be MINUTES since that is what Elias paper uses.

	numDays = 1;
	tend_minutes = 24 * 60 * numDays; %currently set for ___
	%simulation time.
	tspan = [0, tend_minutes];

	%Just using these default values. They seem fine for now, we might find it useful to adjust later. I'm also using the
	%low order solver ode23. We may need to change this later too.
	opts = odeset('AbsTol',1e-3,'RelTol',1e-5,'MaxStep',6,'InitialStep',.1);
	[t,x] = ode23(@f,tspan,x0,opts);
    if plt == true
        subplot(1,3,1)
        varsToPlot = [2 5 6];
        plot(t / 60,x(:,varsToPlot));
        xlabel('Time [hrs]');
        legend(N(varsToPlot));

        %here replicate stuff plotted in Elias figure 4.8
        subplot(1,3,2)
%       varsToPlot = [P_ATMNucPhos P_P53NucPhos P_MDM2Nuc P_WIP1Nuc];
        varsToPlot = [P_ATMNucPhos P_P53NucPhos P_MDM2Nuc P_WIP1Nuc];
        h = plot(t / 60,x(:,varsToPlot));
        set(h(1),'color', 'r');
        set(h(2),'color', 'g');
        set(h(3),'color', 'b');
        set(h(4),'color', 'k');
        xlabel('Time [hrs]');
        legend(N(varsToPlot));

        subplot(1,3,3)
%       varsToPlot = [P_ATMNucPhos P_P53NucPhos P_MDM2Nuc P_WIP1Nuc];
        varsToPlot = [O_CELLCYCLING O_ARRESTSIGNAL P_ECDK2 P_p21cip];
        h = plot(t / 60,x(:,varsToPlot));
        xlabel('Time [hrs]');
        legend(N(varsToPlot));
    else
        %here display the output value we will do machine learning on. for
        %now I'll just use the final value of cell cycling. this will not
        %be what we use eventually, just a placeholder for now. put
        %plt to false to see this printed out.
        x(end, O_CELLCYCLING)
    end


	function xd=f(t,x)

		%In this function we have the differential equations.

		%I'm hoping calling this script at every entrance to this function won't slow things
		%down too much. I don't think it will. If it does we might consider using globals or something like that.

		variableDefinition2;


		%Declare the constant holders
		%TODO: This may be a bit general, consider breaking up into permeability rate, degradation rate, transcription etc.
		%TODO: Make them global, it slows the ODE solver down a bit if we have to redeclare them at every timestep.
		RATE_CONSTANTS = struct();
		PROTEINS = struct();
		VOLUME_RATIOS = struct();

		%We start with all the parameters of those equations. We might want to think a little more
		%about an organized nomenclature for these. For example it would be nice to be able to tell from the name
		%basically what it is doing. But we also don't want to be cumbersome and have really long names (I think..).
		%So for now we will go with this but we might come up with a more refined standard.
		c_Kiri = .03;
		c_Kbe = .03;
		c_Kbec = .004; %decreasinging this to slow down repair process
		c_Kc = .02;
		c_Kcc = .01; %caps clearance rate/halflife term
		c_Mc = .01;
		c_Kcer = .01;
		c_Kf = .01;


		%next come constants from the Elias paper https://hal.inria.fr/hal-00822308/document
		PROTEINS = setfield(PROTEINS, "ATMtot", 1.3); %total concentration of ATM proteins (monomers and dimers)

		%E = 2.5e-5; % signal produced by DNA damage [orig Elias model, I
		%their E in the paper was anything from  2.5e-5 to 10. can use the parameter Kph2 to do this scaling.

		%do it differently]
		% the system's constants, for the full description see Table B.1

		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "k3", 3); %p53 Phosphorylation Velocity
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "Katm", 0.1); %Mich.-Men. rate of p53 phosph.
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "kdph1", 7800); %Wip1-dependent p53 dephosph. velocity. craft: changing this to see if i can get p53nucphos to taper out faster. original value: 78
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "Kdph1", 250); %Mich.-Men. rate of Wip1-dependent p53 dephosph. Craft: try this one too (original value 25)
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "k1", 10); %p53 ubiquitination velocity
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "K1", 1.01); %Mich.-Men. rate of p53 ubiq.
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "pp", 0.083); %p53 permeability
		VOLUME_RATIOS = setfield(VOLUME_RATIOS, "Vr", 10); %Volume ratio
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "pm", 0.04); %Mdm2 permeability
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "deltam", 0.16); %Mdm2 degradation rate
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "kSm", 0.005); %Basal Mdm2 RNA transcription rate
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "kSpm", 1); %Mdm2 RNA transcription velocity
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "KSpm", 0.1); %Mich.-Men. rate of Mdm2 RNA trans.
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "pmrna", 0.083); %Mdm2 RNA permeability
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "deltamrna", 0.0001); %Mdm2 RNA degradation rate
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "ktm", 1); %Mdm2 translation rate
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "kS", 0.015); %Basal p53 synthesis rate
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "deltap", 0.2); %p53 degradation rate
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "pw", 0.083); %Wip1 permeability
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "deltaw", 0.2); %Wip1 degradation rate
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "kSw", 0.03); %Basal Wip1 RNA transcription rate
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "kSpw", 1); %Wip1 RNA transcription velocity
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "KSpw", 0.1); %Mich.-Men. rate of Wip1 RNA trans.
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "pwrna", 0.083); %Wip1 RNA permeability
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "deltawrna", 0.001); %Wip1-dependent ATM dephosph. velocity
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "ktw", 1); %Wip1 translation rate

		% this next one to modify the radiation impact:
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "kph2", 15); %ATM phosphorylation velocity
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "Kph2", 1); %Mich.-Men. rate of ATM phosph.

		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "kdph2", 1); %Wip1-dependent ATM dephosph. velocity
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "Kdph2", 1); %Mich.-Men. rate of Wip1-dependent ATM dephosph.

		% nondimensionalisation of the variables is done so that the term relative to
		% the main bifurcation parameter E depends on as small possible number of
		% parameters as possible. Other choices are, of course, possible.
		%barE = E/Kph2;
		ts = 1 / RATE_CONSTANTS.kph2;
		alpha1 = RATE_CONSTANTS.Katm;
		alpha4 = alpha1;
		alpha2 = RATE_CONSTANTS.kSpm / RATE_CONSTANTS.k3;
		alpha3 = alpha2;
		alphav1 = RATE_CONSTANTS.Kph2;
		alphav2 = alphav1;
		alphaw1 = RATE_CONSTANTS.kSpw / RATE_CONSTANTS.k3 * 10;
		alphaw2 = alphaw1;
		barkdph1 = ts * RATE_CONSTANTS.kdph1 * (alphaw1 / alpha1);
		barKdph1 = RATE_CONSTANTS.Kdph1 / alpha4;
		bark1 = ts * RATE_CONSTANTS.k1 * (alpha2 / alpha1);
		barK1 = RATE_CONSTANTS.K1 / alpha1;

		bark3 = ts * RATE_CONSTANTS.k3 * (alphav2 / alpha1);
		barKatm = RATE_CONSTANTS.Katm / alpha1;
		barpp = ts * RATE_CONSTANTS.pp;
		barpm = ts * RATE_CONSTANTS.pm;
		bardeltam = ts * RATE_CONSTANTS.deltam;
		barkSm = ts * RATE_CONSTANTS.kSm / alpha3;
		barkSpm = ts * RATE_CONSTANTS.kSpm / alpha3;
		barKSpm = RATE_CONSTANTS.KSpm / alpha4;
		barpmrna = ts * RATE_CONSTANTS.pmrna;
		bardeltamrna = ts * RATE_CONSTANTS.deltamrna;
		barpw = ts * RATE_CONSTANTS.pw;
		bardeltaw = ts * RATE_CONSTANTS.deltaw;
		barkSw = ts * RATE_CONSTANTS.kSw / alphaw2;
		barkSpw = ts * RATE_CONSTANTS.kSpw / alphaw2;
		barKSpw = RATE_CONSTANTS.KSpw / alpha4;
		barpwrna = ts * RATE_CONSTANTS.pwrna;
		bardeltawrna = ts * RATE_CONSTANTS.deltawrna;
		barkdph2 = ts * RATE_CONSTANTS.kdph2 * (alphaw1 / alphav2);
		barKdph2 = RATE_CONSTANTS.Kdph2 / (alphav2^2);
		barkS = ts * RATE_CONSTANTS.kS / alpha1;
		bardeltap = ts * RATE_CONSTANTS.deltap;
		barktm = ts * RATE_CONSTANTS.ktm;
		barktw = ts * RATE_CONSTANTS.ktw;
		ATMtot = PROTEINS.ATMtot / alphav1;



		%Apoptosis Rate Constants --> p53 to Cyt c model
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpB1", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpB2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpB3", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpBX1", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpBX2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpBX3", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpF1", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpF2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpF3", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpBa1", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpBa2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpBa3", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KBaxC", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KBcl2C", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KBclXC", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KCyt", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KAA", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KAA2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KApop", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KApop2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KApop3", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_Kpp1", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_Kpp2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_Kpp3", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpE1", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpE2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KpE3", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_KE", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "KRb", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_Ka1", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "c_Ka2", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "KRb", 1);
		RATE_CONSTANTS = setfield(RATE_CONSTANTS, "Kg", 1);



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
		% equations for the nucleus (B.1)
		% p53
		xd(P_P53Nuc) = barkdph1 * x(P_WIP1Nuc) * (x(P_P53NucPhos) / (barKdph1 + x(P_P53NucPhos)))- bark1 * x(P_MDM2Nuc) * (x(P_P53Nuc) / (barK1+x(P_P53Nuc))) ...
					-bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc) / (barKatm + x(P_P53Nuc))) - barpp * VOLUME_RATIOS.Vr * (x(P_P53Nuc) - x(P_P53Cyto));
		% Mdm2
		xd(P_MDM2Nuc) = -barpm * VOLUME_RATIOS.Vr * (x(P_MDM2Nuc) - x(P_MDM2Cyto)) - bardeltam * x(P_MDM2Nuc);
		% Mdm2 mRNA
		xd(M_MDM2Nuc) = barkSm + barkSpm * (x(P_P53NucPhos)^4 / (barKSpm^4 + x(P_P53NucPhos)^4)) - barpmrna * VOLUME_RATIOS.Vr * x(M_MDM2Nuc) ...
					-bardeltamrna * x(M_MDM2Nuc);
		% p53_p
		xd(P_P53NucPhos) = bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc) / (barKatm + x(P_P53Nuc))) - barkdph1 * x(P_WIP1Nuc) * (x(P_P53NucPhos) / (barKdph1 + x(P_P53NucPhos)));
		%Wip1
		xd(P_WIP1Nuc) = barpw * VOLUME_RATIOS.Vr * x(P_WIP1Cyto) - bardeltaw * x(P_WIP1Nuc);
		%Wip1 mRNA
		xd(M_WIP1Nuc)= barkSw + barkSpw * (x(P_P53NucPhos)^4 / (barKSpw^4 + x(P_P53NucPhos)^4)) -barpwrna * VOLUME_RATIOS.Vr * x(M_WIP1Nuc) ...
					-bardeltawrna * x(M_WIP1Nuc);
		% Atm_p
		%here we are replacing their E with "broken ends": assuming
		%"danger signal" is proportional to number of broken ends:
		%xd(P_ATMNucPhos)=2*Kph2*0.1*( ((ATMtot-x(P_ATMNucPhos))/2)/(1+((ATMtot-x(P_ATMNucPhos))/2) )) -2*barkdph2*x(P_WIP1Nuc)*(x(P_ATMNucPhos)^2/(barKdph2+x(P_ATMNucPhos)^2));
		xd(P_ATMNucPhos) = 2 * RATE_CONSTANTS.Kph2 * x(O_BROKEN_ENDS) * (((PROTEINS.ATMtot - x(P_ATMNucPhos)) / 2) / (1 + ((ATMtot - x(P_ATMNucPhos))/2))) - 2 * barkdph2 * x(P_WIP1Nuc) * (x(P_ATMNucPhos)^2 / (barKdph2 + x(P_ATMNucPhos)^2));


		% equations for the cytoplasm (B.2)
		% p53
		xd(P_P53Cyto) = barkS - bark1 * x(P_MDM2Cyto) * (x(P_P53Cyto) / (barK1 + x(P_P53Cyto))) - bardeltap * x(P_P53Cyto) - barpp * (x(P_P53Cyto) - x(P_P53Nuc));
		% Mdm2
		xd(P_MDM2Cyto) = barktm * x(M_MDM2Cyto) - barpm * (x(P_MDM2Cyto)-x(P_MDM2Nuc)) - bardeltam * x(P_MDM2Cyto);
		% Mdm2 mRNA
		xd(M_MDM2Cyto) = barpmrna * x(M_MDM2Nuc) - barktm * x(M_MDM2Cyto) - bardeltamrna * x(M_MDM2Cyto);
		% Wip1
		xd(P_WIP1Cyto) = barktw * x(M_WIP1Cyto) - barpw * x(P_WIP1Cyto) - bardeltaw * x(P_WIP1Cyto);
		% Wip1 mRNA
		xd(M_WIP1Cyto) = barpwrna * x(M_WIP1Nuc) - barktw * x(M_WIP1Cyto) - bardeltawrna * x(M_WIP1Cyto);

        %Apoptosis --> p53 to Cytochrome c
        %and apoptosome
        %BCl-2
        xd(P_Bcl2) = RATE_CONSTANTS.c_KpB1 * (x(P_P53NucPhos)^4) / (RATE_CONSTANTS.c_KpB2 + x(P_P53NucPhos)^4) - RATE_CONSTANTS.c_KpB3 * x(P_Bcl2);
        %Bcl-Xl
        xd(P_BclXl) = RATE_CONSTANTS.c_KpBX1 * (x(P_P53NucPhos)^4) / (RATE_CONSTANTS.c_KpBX2 + x(P_P53NucPhos)^4) - RATE_CONSTANTS.c_KpBX3 * x(P_BclXl);
        %Fas-l
        xd(P_FasL) = RATE_CONSTANTS.c_KpF1 * (x(P_P53NucPhos)^4) / (RATE_CONSTANTS.c_KpF2 + x(P_P53NucPhos)^4) - RATE_CONSTANTS.c_KpF3 * x(P_FasL);
        %BAX
        xd(P_Bax) = RATE_CONSTANTS.c_KpBa1 * (x(P_P53NucPhos)^4) / (RATE_CONSTANTS.c_KpBa2 + x(P_P53NucPhos)^4) - RATE_CONSTANTS.c_KpBa3 * x(P_Bax);
        %Cytochrome c
        xd(P_CytC) = RATE_CONSTANTS.c_KBaxC*(x(P_Bax)) - RATE_CONSTANTS.c_KBcl2C*(x(P_Bcl2)) - RATE_CONSTANTS.c_KBclXC * (x(P_BclXl)) - RATE_CONSTANTS.c_KCyt * (x(P_CytC)) ...
            				- RATE_CONSTANTS.c_KAA*x(P_Apoptosome)*x(P_CytC)^7;
        %Apoptosome
        xd(P_Apoptosome) = RATE_CONSTANTS.c_KAA * x(P_Apoptosome) * x(P_CytC)^7 - RATE_CONSTANTS.c_KAA2 * x(P_Apoptosome);
        %Apoptosis
        xd(P_Apoptosis) = RATE_CONSTANTS.c_KApop * x(P_FasL) + RATE_CONSTANTS.c_KApop2 * x(P_Apoptosome) - RATE_CONSTANTS.c_KApop3 * x(P_Apoptosis);

        %Cell cycle arrest module --> p53 -- p21cip -- ECDK2 --pRb
        %p21cip
        xd(P_p21cip) = RATE_CONSTANTS.c_Kpp1 * (x(P_P53NucPhos)^4) / (RATE_CONSTANTS.c_Kpp2 + x(P_P53NucPhos)^4) - RATE_CONSTANTS.c_Kpp3 * x(P_p21cip);
        %ECDK2
        xd(P_ECDK2) = RATE_CONSTANTS.c_KpE1 - RATE_CONSTANTS.c_KpE2 * x(P_p21cip) / (RATE_CONSTANTS.c_KpE3 + x(P_p21cip)) - RATE_CONSTANTS.c_KE * x(P_ECDK2);

       	%Cell Cycle Arrest, Note: kRb should either be on or off (represents gene)
        %Note: Krb should have negative sign in front but will produce negative graphs, thus made positive
        %Double check this later
        xd(O_ARRESTSIGNAL) = (-RATE_CONSTANTS.KRb * RATE_CONSTANTS.c_Ka1 * xd(P_ECDK2) * exp(-RATE_CONSTANTS.c_Ka1 * (x(P_ECDK2)- RATE_CONSTANTS.c_Ka2)))/ ...
            (1+ exp(-RATE_CONSTANTS.c_Ka1*(x(P_ECDK2) - RATE_CONSTANTS.c_Ka2)))^2;
        %Cell Cycling, Note: Kg represents growth constant
        xd(O_CELLCYCLING) = -RATE_CONSTANTS.Kg * xd(O_ARRESTSIGNAL);
