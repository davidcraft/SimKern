function v3()
    % set plt = true to plot the graph
    plt = true;
        global single; single = true;
    %this is the master sim0 version 2.0

    %note for octave compatibility, must install odepkg for octave and also execute the following line
    %every session.
    %pkg load odepkg
    %Alternately, make a file called .octaverc in your home directory, and put that line in the file.
    %we'll have to verify that this works when calling octave through python.


    %ENTITIES in the model:
    %These are the proteins, mRNA, etc., each of which has an ODE describing its dynamics, which we store in a file
    %so we can re-use in the ODE function.
    variableDefinition3

    %Initial conditions
    x0 = zeros(numEntities,1);
    %here any non-zero initial conditions
    %for now, we we are modeling our radiation blast as an exponetially decaying level, we just initialize
    %the radiation compartment.
    x0(O_CELLCYCLING) = 1;
        x0(P_ECDK2) = 1;
        x0(O_RADIATION) = 1;
        x0(P_E2F) = 1;


    %Simulation time span. We will take the units of time to be MINUTES since that is what Elias paper uses.

    numDays=1;
    Tend_minutes = 24*60*numDays; %currently set for ___
                                      %simulation time.
    tspan=[0,Tend_minutes];

    %Just using these default values. They seem fine for now, we might find it useful to adjust later. I'm also using the
    %low order solver ode23. We may need to change this later too.
    opts = odeset('AbsTol',1e-3,'RelTol',1e-5,'MaxStep',6,'InitialStep',.1);
    [t,x]=ode23(@f,tspan,x0,opts);
    if plt == true
        subplot(1,3,1)
        varsToPlot = [2 5 6];
        plot(t/60,x(:,varsToPlot));
        xlabel('Time [hrs]');
        legend(N(varsToPlot));

        %here replicate stuff plotted in Elias figure 4.8
        subplot(1,3,2)
        varsToPlot = [P_ATMNucPhos P_P53NucPhos P_MDM2Nuc P_WIP1Nuc P_Siah P_Reprimo];
        %varsToPlot = [P_Siah P_Reprimo];
        h=plot(t/60,x(:,varsToPlot));
        set(h(1),'color', 'r');
        set(h(2),'color', 'g');
        set(h(3),'color', 'b');
        set(h(4),'color', 'k');
        xlabel('Time [hrs]');
        legend(N(varsToPlot));

        subplot(1,3,3)
        %varsToPlot = [P_ATMNucPhos P_P53NucPhos P_MDM2Nuc P_WIP1Nuc];
        varsToPlot = [O_CELLCYCLING O_ARRESTSIGNAL P_ARF P_E2F];
        h=plot(t/60,x(:,varsToPlot));
        xlabel('Time [hrs]');
        legend(N(varsToPlot));
    else
        %here display the output value we will do machine learning on. for
        %now I'll just use the final value of cell cycling. this will not
        %be what we use eventually, just a placeholder for now. put
        %plt to false to see this printed out.
        x(end,O_CELLCYCLING)
    end

    function xd=f(t,x)

        %In this function we have the differential equations.

        %I'm hoping calling this script at every entrance to this function won't slow things
        %down too much. I don't think it will. If it does we might consider using globals or something like that.

        global single;
        variableDefinition3;

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
        ATMtot = 1.3; % total concentration of ATM proteins (monomers and dimers)
        %E = 2.5e-5; % signal produced by DNA damage [orig Elias model, I
        %their E in the paper was anything from  2.5e-5 to 10. can use the parameter Kph2 to do this scaling.

        %do it differently]
        % the system's constants, for the full description see Table B.1


        k3=3;
        Katm=0.1;
        kdph1=7800; %craft: changing this to see if i can get
                          %p53nucphos to taper out faster. orig
                          %value: 78
        Kdph1=250; %try this one too
        k1=10;
        K1=1.01;
        pp=0.083;
        Vr=10;
        pm=0.04;
        deltam=0.16;
        kSm=0.005;
        kSpm=1;
        KSpm=0.1;
        pmrna=0.083;
        deltamrna=0.0001;
        ktm=1;
        kS=0.015;
        deltap=0.2;
        pw=0.083;
        deltaw=0.2;
        kSw=0.03;
        kSpw=1;
        KSpw=0.1;
        pwrna=0.083;
        deltawrna=0.001;
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
        barpp=ts*pp; barpm=ts*pm; bardeltam=ts*deltam;
        barkSm=ts*kSm/alpha3; barkSpm=ts*kSpm/alpha3; barKSpm=KSpm/alpha4;
        barpmrna=ts*pmrna; bardeltamrna=ts*deltamrna;
        barpw=ts*pw; bardeltaw=ts*deltaw;
        barkSw=ts*kSw/alphaw2; barkSpw=ts*kSpw/alphaw2; barKSpw=KSpw/alpha4;
        barpwrna=ts*pwrna; bardeltawrna=ts*deltawrna;
        barkdph2=ts*kdph2*(alphaw1/alphav2); barKdph2=Kdph2/(alphav2^2);
        barkS=ts*kS/alpha1; bardeltap=ts*deltap;
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
        c_KpE2 = 2;
        c_KpE3 = 1;
        c_KE = 1;
        K_Rb = 2;
        c_Ka1 = 5;
        c_Ka2 = 1;
        Kg = 1;
        K_MYC = 2;
        c_E2F1 = 1;
        c_ARF1 = 1;
        c_ARF2 = 1;
        c_ARF3 = 1;
        c_MDM2Nuc1 = 1;
        c_MDM2Nuc2 = 1;
        c_Kps = 15;
        c_Kps2 = .1;
        c_si = 2;
        c_Kpr = 1.8;
        c_Kpr2 = 9;
        c_re = 1;


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


        if single
            %Elias paper https://hal.inria.fr/hal-00822308/document
            % equations for single compartment model (C.1)
            % p53
            xd(P_P53Nuc) = barkS + barkdph1 * x(P_WIP1Nuc) * ((x(P_P53NucPhos)/(barKdph1+x(P_P53NucPhos)))) ...
                - bark1 * x(P_MDM2Nuc) * (x(P_P53Nuc)/(barK1+x(P_P53Nuc))) ...
                        -bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc)/(barKatm+x(P_P53Nuc))) - deltap*(x(P_P53Nuc));
            % Mdm2
            xd(P_MDM2Nuc) = barktm * x(M_MDM2Nuc) - x(P_MDM2Nuc);
            % Mdm2 mRNA
            xd(M_MDM2Nuc) = barkSm + barkSpm * (x(P_P53NucPhos)^4/(barKSpm^4+x(P_P53NucPhos)^4)) - deltamrna * x(M_MDM2Nuc) ...
                        - barktm * x(M_MDM2Nuc);
            % p53_p
            xd(P_P53NucPhos) = bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc)/(barKatm+x(P_P53Nuc))) - barkdph1*x(P_WIP1Nuc)*(x(P_P53NucPhos)/(barKdph1+x(P_P53NucPhos)));
            %Wip1
            xd(P_WIP1Nuc) = barktw * x(M_WIP1Nuc) - deltaw * x(P_WIP1Nuc);
            %Wip1 mRNA
            xd(M_WIP1Nuc) = barkSw + barkSpw * (x(P_P53NucPhos)^4/(barKSpw^4+x(P_P53NucPhos)^4)) - deltawrna * x(M_WIP1Nuc) ...
                        - barktw * x(M_WIP1Nuc);
            % Atm_p
            %here we are replacing their E with "broken ends": assuming
            %"danger signal" is proportional to number of broken ends:
            %xd(P_ATMPhos)=2*Kph2*0.1*( ((ATMtot-x(P_ATMPhos))/2)/(1+((ATMtot-x(P_ATMPhos))/2) )) -2*barkdph2*x(P_WIP1)*(x(P_ATMPhos)^2/(barKdph2+x(P_ATMPhos)^2));
            xd(P_ATMNucPhos) = 2*Kph2 * x(O_BROKEN_ENDS) * ((ATMtot- x(P_ATMNucPhos))/2)/(barKdph2 + ((ATMtot - x(P_ATMNucPhos))/2)) ...
                -2*barkdph2 * x(P_WIP1Nuc) * (x(P_ATMNucPhos)^2/(barKdph2 + x(P_ATMNucPhos)^2));

        else
            %Elias paper https://hal.inria.fr/hal-00822308/document
            % equations for the nucleus (B.1)
            % p53
            xd(P_P53Nuc) = barkdph1 * x(P_WIP1Nuc) * (x(P_P53NucPhos) / (barKdph1 + x(P_P53NucPhos)))- bark1 * x(P_MDM2Nuc) * (x(P_P53Nuc) / (barK1+x(P_P53Nuc))) ...
                        -bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc) / (barKatm + x(P_P53Nuc))) - barpp * Vr * (x(P_P53Nuc) - x(P_P53Cyto));
            % Mdm2
            xd(P_MDM2Nuc) = -barpm * Vr * (x(P_MDM2Nuc) - x(P_MDM2Cyto)) - bardeltam * x(P_MDM2Nuc);
            % Mdm2 mRNA
            xd(M_MDM2Nuc) = barkSm + barkSpm * (x(P_P53NucPhos)^4 / (barKSpm^4 + x(P_P53NucPhos)^4)) - barpmrna * Vr * x(M_MDM2Nuc) ...
                        -bardeltamrna * x(M_MDM2Nuc);
            % p53_p
            xd(P_P53NucPhos) = bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc) / (barKatm + x(P_P53Nuc))) - barkdph1 * x(P_WIP1Nuc) * (x(P_P53NucPhos) / (barKdph1 + x(P_P53NucPhos)));
            %Wip1
            xd(P_WIP1Nuc) = barpw * Vr * x(P_WIP1Cyto) - bardeltaw * x(P_WIP1Nuc);
            %Wip1 mRNA
            xd(M_WIP1Nuc)= barkSw + barkSpw * (x(P_P53NucPhos)^4 / (barKSpw^4 + x(P_P53NucPhos)^4)) -barpwrna * Vr * x(M_WIP1Nuc) ...
                        -bardeltawrna * x(M_WIP1Nuc);
            % Atm_p
            %here we are replacing their E with "broken ends": assuming
            %"danger signal" is proportional to number of broken ends:
            %xd(P_ATMNucPhos)=2*Kph2*0.1*( ((ATMtot-x(P_ATMNucPhos))/2)/(1+((ATMtot-x(P_ATMNucPhos))/2) )) -2*barkdph2*x(P_WIP1Nuc)*(x(P_ATMNucPhos)^2/(barKdph2+x(P_ATMNucPhos)^2));
            xd(P_ATMNucPhos) = 2 * Kph2 * x(O_BROKEN_ENDS) * (((ATMtot - x(P_ATMNucPhos)) / 2) / (1 + ((ATMtot - x(P_ATMNucPhos))/2))) - 2 * barkdph2 * x(P_WIP1Nuc) * (x(P_ATMNucPhos)^2 / (barKdph2 + x(P_ATMNucPhos)^2));


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

        end

        %Apoptosis Pathways
        %and apoptosome
        %BCl-2
        xd(P_Bcl2) = c_KpB1*(x(P_P53NucPhos)^4)/(c_KpB2 + x(P_P53NucPhos)^4) - c_KpB3 * x(P_Bcl2);
        %Bcl-Xl
        xd(P_BclXl) = c_KpBX1*(x(P_P53NucPhos)^4)/(c_KpBX2 + x(P_P53NucPhos)^4) - c_KpBX3 * x(P_BclXl);
        %Fas-l
        xd(P_FasL) = c_KpF1*(x(P_P53NucPhos)^4)/(c_KpF2 + x(P_P53NucPhos)^4) - c_KpF3 * x(P_FasL);
        %BAX
        xd(P_Bax) = c_KpBa1*(x(P_P53NucPhos)^4)/(c_KpBa2 + x(P_P53NucPhos)^4) - c_KpBa3 * x(P_Bax);
        %Cytochrome c
        xd(P_CytC) = c_KBaxC*(x(P_Bax)) - c_KBcl2C*(x(P_Bcl2)) - c_KBclXC*(x(P_BclXl)) - c_KCyt*(x(P_CytC)) ...
            - c_KAA*x(P_Apoptosome)*x(P_CytC)^7;
        %Apoptosome
        xd(P_Apoptosome) = c_KAA*x(P_Apoptosome)*x(P_CytC)^7 - c_KAA2 *x(P_Apoptosome);
        %Apoptosis
        xd(P_Apoptosis) = c_KApop*x(P_FasL) + c_KApop2 * x(P_Apoptosome) - c_KApop3 * x(P_Apoptosis);

        %MYC --> p53
        %E2F
        xd(P_E2F) = K_Rb*K_MYC - c_E2F1*x(P_E2F);
        %ARF
        xd(P_ARF) = c_ARF1 * (x(P_E2F)/(c_ARF2+x(P_E2F))) - c_ARF3 * x(P_ARF);


        %Cell cycle arrest modules --> p53 -- p21cip -- ECDK2 --pRb
        %p21cip
        xd(P_p21cip) = c_Kpp1*(x(P_P53NucPhos)^4)/(c_Kpp2 + x(P_P53NucPhos)^4) - c_Kpp3 * x(P_p21cip);
        %ECDK2
        xd(P_ECDK2) = c_KpE1 - c_KpE2*x(P_p21cip)/(c_KpE3 + x(P_p21cip)) - c_KE * x(P_ECDK2);
        %Cell Cycle Arrest, Note: kRb should either be on or off (represents gene)
        %Note: Krb should have negative sign in front but will produce negative graphs, thus made positive
        %Double check this later
        xd(O_ARRESTSIGNAL) = (-K_Rb*c_Ka1*xd(P_ECDK2)*exp(-c_Ka1*(x(P_ECDK2)- c_Ka2)))/ ...
            (1+ exp(-c_Ka1*(x(P_ECDK2)- c_Ka2)))^2;
        %Cell Cycling, Note: Kg represents growth constant
        xd(O_CELLCYCLING) = -Kg*xd(O_ARRESTSIGNAL);
        %Siah
        xd(P_Siah) = c_Kps*(x(P_P53NucPhos)^4)/(c_Kps2 + x(P_P53NucPhos)^4) - c_si * x(P_Siah);
        %Reprimo
        xd(P_Reprimo) = c_Kpr*(x(P_P53NucPhos)^4)/(c_Kpr2 + x(P_P53NucPhos)^4) - c_re * x(P_Reprimo);
