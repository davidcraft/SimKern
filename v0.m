function v0()
	%this is the master sim0 version 1.0

	%note for octave compatibility, must install odepkg for octave and also execute the following line
	%every session. 
	%  pkg load odepkg
	%Alternately, make a file called .octaverc in your home directory, and put that line in the file.
	%we'll have to verify that this works when calling octave through python.

	
	%ENTITIES in the model:
	%These are the proteins, mRNA, etc., each of which has an ODE describing its dynamics, which we store in a file
	%so we can re-use in the ODE function.
	variableDefinition

	
	%Initial conditions
	x0 = zeros(numEntities,1);
	%here any non-zero initial conditions
	%for now, we we are modeling our radiation blast as an exponetially decaying level, we just initialize
	%the radiation compartment.
	x0(O_RADIATION) = 1;


	%Simulation time span. We will take the units of time to be hours [a human cell cycles, in good growth conditions, on
	%the order of one cell cycle per day. even though at this point we are not modeling the cell cycle, hours seems like
	%a good time unit for us].

	Tend_hours = 48;
	tspan=[0,Tend_hours];

	%Just using these default values. They seem fine for now, we might find it useful to adjust later. I'm also using the
	%low order solver ode23. We may need to change this later too.
	opts = odeset('AbsTol',1e-3,'RelTol',1e-5,'MaxStep',6,'InitialStep',.1);
	[t,x]=ode23(@f,tspan,x0,opts);

	varsToPlot = [2 5 6];
	plot(t,x(:,varsToPlot));
	legend(N(varsToPlot));

	function xd=f(t,x)

		%In this function we have the differential equations.

		%I'm hoping calling this script at every entrance to this function won't slow things
		%down too much. I don't think it will. If it does we might consider using globals or something like that.

		variableDefinition
		
		%We start with all the parameters of those equations. We might want to think a little more
		%about an organized nomenclature for these. For example it would be nice to be able to tell from the name
		%basically what it is doing. But we also don't want to be cumbersome and have really long names (I think..).
		%So for now we will go with this but we might come up with a more refined standard.
		c_Kiri = 1.0;
		c_Kbe = 3.0;
		c_Kbec = 1.0;
		c_Kc = 2.5;
		c_Kcc = 1; %caps clearance rate/halflife term
		c_Mc = 1.0;
		c_Kcer = 1.0;
		c_Kf = 1.0;
		
		% assign the initial value
		%o_radiation = x(1);
		%o_brokenDNAEnds = x(2);
		%o_caps = x(3);
		%o_cappedEnds = x(4);
		%o_cappedEndsRepaire = x(5);
		%o_fixedDNAEnds = x(6);

		% the differential equations:
		xd = zeros(numEntities,1);
		
		% the odes

		xd(O_RADIATION) = -c_Kiri * x(O_RADIATION);
		xd(O_BROKEN_ENDS) = c_Kbe * x(O_RADIATION) - c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS);
		xd(O_CAPS) = min((c_Kc * x(O_BROKEN_ENDS)) ,c_Mc) - c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS) ...
							 - c_Kcc * x(O_CAPS);
		xd(O_CAPPED_ENDS) = c_Kbec * x(O_BROKEN_ENDS) * x(O_CAPS) -c_Kcer * x(O_CAPPED_ENDS);
		xd(O_CAPPED_ENDS_READY) = c_Kcer * x(O_CAPPED_ENDS) - c_Kf * x(O_CAPPED_ENDS_READY);
		xd(O_FIXED) = c_Kf * x(O_CAPPED_ENDS_READY);
		
