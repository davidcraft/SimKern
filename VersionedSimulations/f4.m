    function xd=f4(t,x,RP)

        %In this function we have the differential equations.

        %I'm hoping calling this script at every entrance to this function won't slow things
        %down too much. I don't think it will. If it does we might consider using globals or something like that.

        global single;
     
        variableDefinition3
        xd = zeros(numEntities,1);

        % the odes

        %DNA impact and repair kinetics
        xd(O_RADIATION) = -RP.c_Kiri * x(O_RADIATION);
        xd(O_BROKEN_ENDS) = RP.c_Kbe * x(O_RADIATION) - RP.c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS);
        xd(O_CAPS) = min((RP.c_Kc * x(O_BROKEN_ENDS)) ,RP.c_Mc) - RP.c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS) ...
                             - c_Kcc * x(O_CAPS);
        xd(O_CAPPED_ENDS) = RP.c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS) -RP.c_Kcer * x(O_CAPPED_ENDS);
        xd(O_CAPPED_ENDS_READY) = RP.c_Kcer * x(O_CAPPED_ENDS) - RP.c_Kf * x(O_CAPPED_ENDS_READY);
        xd(O_FIXED) = RP.c_Kf * x(O_CAPPED_ENDS_READY);


        if single
            %Elias paper https://hal.inria.fr/hal-00822308/document
            % equations for single compartment model (C.1)
            % p53
            xd(P_P53Nuc) = RP.barkS + RP.barkdph1 * x(P_WIP1Nuc) * ((x(P_P53NucPhos)/(RP.barKdph1+x(P_P53NucPhos)))) ...
                - RP.bark1 * x(P_MDM2Nuc) * (x(P_P53Nuc)/(RP.barK1+x(P_P53Nuc))) ...
                        -RP.bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc)/(RP.barKatm+x(P_P53Nuc))) - RP.deltap*(x(P_P53Nuc));
            % Mdm2
            xd(P_MDM2Nuc) = RP.barktm * x(M_MDM2Nuc) - x(P_MDM2Nuc);
            % Mdm2 mRNA
            xd(M_MDM2Nuc) = RP.barkSm + RP.barkSpm * (x(P_P53NucPhos)^4/(RP.barKSpm^4+x(P_P53NucPhos)^4)) - RP.deltamrna * x(M_MDM2Nuc) ...
                        - RP.barktm * x(M_MDM2Nuc);
            % p53_p
            xd(P_P53NucPhos) = RP.bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc)/(RP.barKatm+x(P_P53Nuc))) - RP.barkdph1*x(P_WIP1Nuc)*(x(P_P53NucPhos)/(RP.barKdph1+x(P_P53NucPhos)));
            %Wip1
            xd(P_WIP1Nuc) = RP.barktw * x(M_WIP1Nuc) - RP.deltaw * x(P_WIP1Nuc);
            %Wip1 mRNA
            xd(M_WIP1Nuc) = RP.barkSw + RP.barkSpw * (x(P_P53NucPhos)^4/(RP.barKSpw^4+x(P_P53NucPhos)^4)) - RP.deltawrna * x(M_WIP1Nuc) ...
                        - RP.barktw * x(M_WIP1Nuc);
            % Atm_p
            %here we are replacing their E with "broken ends": assuming
            %"danger signal" is proportional to number of broken ends:
            %xd(P_ATMPhos)=2*Kph2*0.1*( ((ATMtot-x(P_ATMPhos))/2)/(1+((ATMtot-x(P_ATMPhos))/2) )) -2*barkdph2*x(P_WIP1)*(x(P_ATMPhos)^2/(barKdph2+x(P_ATMPhos)^2));
            xd(P_ATMNucPhos) = 2*RP.Kph2 * x(O_BROKEN_ENDS) * ((RP.ATMtot- x(P_ATMNucPhos))/2)/(RP.barKdph2 + ((RP.ATMtot - x(P_ATMNucPhos))/2)) ...
                -2*RP.barkdph2 * x(P_WIP1Nuc) * (x(P_ATMNucPhos)^2/(RP.barKdph2 + x(P_ATMNucPhos)^2));

        else
            %Elias paper https://hal.inria.fr/hal-00822308/document
            % equations for the nucleus (B.1)
            % p53
            xd(P_P53Nuc) = RP.barkdph1 * x(P_WIP1Nuc) * (x(P_P53NucPhos) / (RP.barKdph1 + x(P_P53NucPhos)))- RP.bark1 * x(P_MDM2Nuc) * (x(P_P53Nuc) / (RP.barK1+x(P_P53Nuc))) ...
                        -RP.bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc) / (RP.barKatm + x(P_P53Nuc))) - RP.barpp * RP.Vr * (x(P_P53Nuc) - x(P_P53Cyto));
            % Mdm2
            xd(P_MDM2Nuc) = -RP.barpm * RP.Vr * (x(P_MDM2Nuc) - x(P_MDM2Cyto)) - RP.bardeltam * x(P_MDM2Nuc);
            % Mdm2 mRNA
            xd(M_MDM2Nuc) = RP.barkSm + RP.barkSpm * (x(P_P53NucPhos)^4 / (RP.barKSpm^4 + x(P_P53NucPhos)^4)) - RP.barpmrna * RP.Vr * x(M_MDM2Nuc) ...
                        -RP.bardeltamrna * x(M_MDM2Nuc);
            % p53_p
            xd(P_P53NucPhos) = RP.bark3 * x(P_ATMNucPhos) * (x(P_P53Nuc) / (RP.barKatm + x(P_P53Nuc))) - RP.barkdph1 * x(P_WIP1Nuc) * (x(P_P53NucPhos) / (RP.barKdph1 + x(P_P53NucPhos)));
            %Wip1
            xd(P_WIP1Nuc) = RP.barpw * RP.Vr * x(P_WIP1Cyto) - RP.bardeltaw * x(P_WIP1Nuc);
            %Wip1 mRNA
            xd(M_WIP1Nuc)= RP.barkSw + RP.barkSpw * (x(P_P53NucPhos)^4 / (RP.barKSpw^4 + x(P_P53NucPhos)^4)) -RP.barpwrna * RP.Vr * x(M_WIP1Nuc) ...
                        -RP.bardeltawrna * x(M_WIP1Nuc);
            % Atm_p
            %here we are replacing their E with "broken ends": assuming
            %"danger signal" is proportional to number of broken ends:
            %xd(P_ATMNucPhos)=2*Kph2*0.1*( ((ATMtot-x(P_ATMNucPhos))/2)/(1+((ATMtot-x(P_ATMNucPhos))/2) )) -2*barkdph2*x(P_WIP1Nuc)*(x(P_ATMNucPhos)^2/(barKdph2+x(P_ATMNucPhos)^2));
            xd(P_ATMNucPhos) = 2 * RP.Kph2 * x(O_BROKEN_ENDS) * (((RP.ATMtot - x(P_ATMNucPhos)) / 2) / (1 + ((RP.ATMtot - x(P_ATMNucPhos))/2))) - 2 * RP.barkdph2 * x(P_WIP1Nuc) * (x(P_ATMNucPhos)^2 / (RP.barKdph2 + x(P_ATMNucPhos)^2));


            % equations for the cytoplasm (B.2)
            % p53
            xd(P_P53Cyto) = RP.barkS - RP.bark1 * x(P_MDM2Cyto) * (x(P_P53Cyto) / (RP.barK1 + x(P_P53Cyto))) - RP.bardeltap * x(P_P53Cyto) - RP.barpp * (x(P_P53Cyto) - x(P_P53Nuc));
            % Mdm2
            xd(P_MDM2Cyto) = RP.barktm * x(M_MDM2Cyto) - RP.barpm * (x(P_MDM2Cyto)-x(P_MDM2Nuc)) - RP.bardeltam * x(P_MDM2Cyto);
            % Mdm2 mRNA
            xd(M_MDM2Cyto) = RP.barpmrna * x(M_MDM2Nuc) - RP.barktm * x(M_MDM2Cyto) - RP.bardeltamrna * x(M_MDM2Cyto);
            % Wip1
            xd(P_WIP1Cyto) = RP.barktw * x(M_WIP1Cyto) - RP.barpw * x(P_WIP1Cyto) - RP.bardeltaw * x(P_WIP1Cyto);
            % Wip1 mRNA
            xd(M_WIP1Cyto) = RP.barpwrna * x(M_WIP1Nuc) - RP.barktw * x(M_WIP1Cyto) - RP.bardeltawrna * x(M_WIP1Cyto);

        end

        %Apoptosis Pathways
        %and apoptosome
        %BCl-2
        xd(P_Bcl2) = RP.c_KpB1*(x(P_P53NucPhos)^4)/(RP.c_KpB2 + x(P_P53NucPhos)^4) - RP.c_KpB3 * x(P_Bcl2);
        %Bcl-Xl
        xd(P_BclXl) = RP.c_KpBX1*(x(P_P53NucPhos)^4)/(RP.c_KpBX2 + x(P_P53NucPhos)^4) - RP.c_KpBX3 * x(P_BclXl);
        %Fas-l
        xd(P_FasL) = RP.c_KpF1*(x(P_P53NucPhos)^4)/(RP.c_KpF2 + x(P_P53NucPhos)^4) - RP.c_KpF3 * x(P_FasL);
        %BAX
        xd(P_Bax) = RP.c_KpBa1*(x(P_P53NucPhos)^4)/(RP.c_KpBa2 + x(P_P53NucPhos)^4) - RP.c_KpBa3 * x(P_Bax);
        %Apaf1
        xd(P_Apaf1) = RP.c_Kapa1*(x(P_P53NucPhos)^4)/(RP.c_Kapa2 + x(P_P53NucPhos)^4) - RP.c_Kapa3 * x(P_Apaf1);
        %Cytochrome c
        xd(P_CytC) = (RP.c_KBaxC1/(1+ exp(-RP.c_KBaxC2*(x(P_Bax)- RP.c_KBaxC3)))) * ...
            RP.c_KBcl2C1 * (1 - 1/(1+ exp(-RP.c_KBcl2C2*(x(P_Bcl2)- RP.c_KBcl2C3)))) * ...
            RP.c_KBclXC1 * (1 - 1/(1+ exp(-RP.c_KBclXC2*(x(P_BclXl)- RP.c_KBclXC3)))) - RP.c_KCyt*(x(P_CytC)) ...
           - RP.c_KAA*x(P_Apaf1)*x(P_CytC)^7;
        %Apoptosome
        xd(P_Apoptosome) = RP.c_KAA*x(P_Apaf1)*x(P_CytC)^7 - RP.c_KAA2 *x(P_Apoptosome);
        %Apoptosis
        xd(O_Apoptosis) = RP.c_KApop*x(P_FasL) + RP.c_KApop2 * x(P_Apoptosome) - RP.c_KApop3 * x(O_Apoptosis);

        %MYC --> p53
        %E2F later on we might model E2F from  
        %Dong,P. et al. Division of labour between Myc and G1 cyclins in cell cycle commitment and pace control. Nat. Commun. 5:4750 doi: 10.1038/ncomms5750 (2014). 
        %website: https://www.nature.com/articles/ncomms5750
        xd(P_E2F) = RP.K_Rb * RP.K_MYC - RP.c_E2F1*x(P_E2F);
        %ARF
        xd(P_ARF) = RP.ARF_muta * (RP.c_ARF1 * (x(P_E2F)/(RP.c_ARF2+x(P_E2F))) - RP.c_ARF3 * x(P_ARF));
       


        %Cell cycle arrest modules --> p53 -- p21cip -- ECDK2 --pRb
        %p21cip
        xd(P_p21cip) = RP.c_Kpp1*(x(P_P53NucPhos)^4)/(RP.c_Kpp2 + x(P_P53NucPhos)^4) - RP.c_Kpp3 * x(P_p21cip);
        %ECDK2
        xd(P_ECDK2) = RP.c_KpE1 - RP.c_KpE2*x(P_p21cip)/(RP.c_KpE3 + x(P_p21cip)) - RP.c_KpE4 * x(P_ECDK2);
        %Cell Cycle Arrest Important Note: Arrest Signal equation found by taking 
        %the derivative of the inverse sigmoid function.
        %Other note: kRb should either be on or off (represents gene)
        xd(O_ARRESTSIGNAL) = (-RP.K_Rb * RP.c_Ka1*xd(P_ECDK2)*exp(-RP.c_Ka1*(x(P_ECDK2)- RP.c_Ka2)))/ ...
            (1+ exp(-RP.c_Ka1*(x(P_ECDK2)- RP.c_Ka2)))^2;
        %Cell Cycling, Note: Kg represents growth constant
        xd(O_CELLCYCLING) = -RP.Kg*xd(O_ARRESTSIGNAL);
        %Siah
        xd(P_Siah) = RP.c_Kps*(x(P_P53NucPhos)^4)/(RP.c_Kps2 + x(P_P53NucPhos)^4) - RP.c_si * x(P_Siah);
        %Reprimo
        xd(P_Reprimo) = RP.c_Kpr*(x(P_P53NucPhos)^4)/(RP.c_Kpr2 + x(P_P53NucPhos)^4) - RP.c_re * x(P_Reprimo);
