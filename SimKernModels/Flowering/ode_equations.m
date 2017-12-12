function dxdt=ode_equations(t, x, parameters, parameters_leaf)
    global	dataTotal...            
	dataTotal_leaf...
	time...
	SVP_expression...
	FLC_expression...
	FT_expression...
	SVP_expression_leaf...
	FLC_expression_leaf...
        MUT;
	    
    Km_AGL24_1		=	parameters(1);	 
			
    Km_SOC1_1		=	parameters(2);	 	
    Km_SOC1_2		=	parameters(3);	 		
    Km_SOC1_3		=	parameters(4);	 	
    Km_SOC1_4		=	parameters(5);	 		
    Km_SOC1_5		=	parameters(6);	 		
    Km_SOC1_6		=	parameters(7);	 		
    
    Km_LFY_1		=	parameters(8);	 
    Km_LFY_2		=	parameters(9);	 
    Km_LFY_3		=	parameters(10);	 
    
    Km_AP1_1		=	parameters(11);	 
    Km_AP1_2		=	parameters(12);	 
    Km_AP1_3		=	parameters(13);	 
    
	Beta_AGL24_1	        =	parameters(14);	 		
	
	Beta_SOC1_1		=	parameters(15);	 		
	Beta_SOC1_2		=	parameters(16);	 		
	Beta_SOC1_3		=	parameters(17);	 			
	
	Beta_LFY_1		=	parameters(18);	 
	Beta_LFY_2		=	parameters(19);	 
	Beta_LFY_3		=	parameters(20);  
	
	Beta_AP1_1		=	parameters(21);	 
	Beta_AP1_2		=	parameters(22);	 
	Beta_AP1_3		=	parameters(23);	 
	
	dc_AGL24		=	parameters(24);	 
	dc_SOC1			=	parameters(25);	 	
	dc_LFY			=	parameters(26);	 
	dc_AP1			=	parameters(27);	 
		
	Delay_FT		=   parameters(28);	 

        Km_FD_1                 =   parameters(29);
        beta_FD_1               =   parameters(30);
        dc_FD                   =   parameters(31);
	
	Km_FT_1		=	parameters_leaf(1);	
	Km_FT_2		=	parameters_leaf(2);

	Beta_FT_1	=	parameters_leaf(3);	

	dc_FT		=	parameters_leaf(4);	
	
	AGL24=x(1);
	SOC1=x(2);	
	LFY=x(3);	
	AP1=x(4);	
	FT=x(5);	
        FD=x(6);

	SVP=polyval(SVP_expression,t);		
	FLC=polyval(FLC_expression,t);		
	SVP_leaf=polyval(SVP_expression_leaf,t);
	FLC_leaf=polyval(FLC_expression_leaf,t);
	
	if(t<5)
			SVP_leaf=dataTotal_leaf(1,1);
			FLC_leaf=dataTotal_leaf(1,2);			
			SVP=dataTotal(1,5);
			FLC=dataTotal(1,6);
	end;
	if(t>17)
			SVP_leaf=dataTotal_leaf(13,1);
			FLC_leaf=dataTotal_leaf(13,2);		
			SVP=dataTotal(13,5);
			FLC=dataTotal(13,6);
	end;
	
        %craft handling of mutations 5-7, the SVP constant ones:
	if MUT.knockdown==1
            if 5==MUT.which
                SVP = dataTotal(1,5)*0.067;
            end
            if 6==MUT.which
                SVP = dataTotal(1,5)*0.033;
            end
            if 7==MUT.which
                SVP = dataTotal(1,5)*0.025;
            end
            if 10==MUT.which %10 is FLC knockout called "FLC-3"
                FLC = 0;
                FLC_leaf=0;
            end
            
        end       
        
        
	if(SVP_leaf<0)
			SVP_leaf=0;
	end;
	if(FLC_leaf<0)
			FLC_leaf=0;
	end;
	if(SVP<0)
			SVP=0;
	end;	
	if(FLC<0)
			FLC=0;
	end;
	if(FT<0)
			FT=0;
	end;
	
	d_AGL24_dt = (Beta_AGL24_1*SOC1/(SOC1+Km_AGL24_1))    - dc_AGL24*AGL24;
	


    d_SOC1_dt =   (((Beta_SOC1_1*AGL24/(Km_SOC1_1+AGL24))+ ...
                 (Beta_SOC1_2*SOC1/(Km_SOC1_2+SOC1)))+((Beta_SOC1_3*FT/(Km_SOC1_3+FT))*(FD/(Km_SOC1_4+FD))))* (Km_SOC1_5/(Km_SOC1_5+SVP) * Km_SOC1_6/(Km_SOC1_6+FLC))   - dc_SOC1*SOC1;

					
	d_LFY_dt =(((Beta_LFY_1*AGL24/(AGL24+Km_LFY_1))+(Beta_LFY_2*SOC1/(SOC1+Km_LFY_2))+(Beta_LFY_3*AP1/(AP1+Km_LFY_3)))) - dc_LFY*LFY;
			
	d_AP1_dt = (Beta_AP1_1*(LFY^3)/((LFY^3)+Km_AP1_1)) +  (Beta_AP1_2*(FT/(FT+Km_AP1_2)))+(Beta_AP1_3*(FD/(FD+Km_AP1_3))) - dc_AP1*AP1;

	d_FT_dt=ode_equation_FT_leaf((t-Delay_FT),FT,parameters_leaf);
			   					 					
    d_FD_dt = beta_FD_1*LFY/(LFY+Km_FD_1)  - dc_FD*FD;

	dxdt=[d_AGL24_dt d_SOC1_dt d_LFY_dt d_AP1_dt d_FT_dt d_FD_dt]';

	if MUT.knockdown==1
            if any([3,4,11,17,18,19]==MUT.which)
                d_AGL24_dt = 0;
            end
            if any([1,2,12,17,18,19]==MUT.which)
                d_SOC1_dt = 0;
            end
            if MUT.which==13
                d_LFY_dt = 0;
            end
            if MUT.which==14
                d_AP1_dt = 0;
            end
            if any([8,15]==MUT.which)
                d_FT_dt=0;
            end
            if any([9,16]==MUT.which)
                d_FD_dt = 0;
            end
        end
