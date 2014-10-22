NEURON {
	POINT_PROCESS ExpSynSTDP
	RANGE tau, e, i, d, p, dtau, ptau, verbose, learning, LR, maxWeight, minWeight, numbre, debug, forSpike, tmp, forDA
	NONSPECIFIC_CURRENT i
}

UNITS {
	(nA) = (nanoamp)
	(mV) = (millivolt)
	(uS) = (microsiemens)
}

PARAMETER {
	tau = 0.1 (ms) <1e-9,1e9>:tau = 0.1 (ms) <1e-9,1e9>
	e = 0	(mV)
	d = 1 <0,1>: depression factor (multiplicative to prevent < 0)
	p = 1 : potentiation factor (additive, non-saturating)
	dtau = 34 (ms) : 34 depression effectiveness time constant
	ptau = 17 (ms) : 17 Bi & Poo (1998, 2001)
	verbose = 0
	learning = 1
	LR = 1:0.0001
	maxWeight = 1
	minWeight = 0
	numbre = 0
	debug = 1
	forSpike = 2 : use to judge whether it fires or not.
	tmp = 0
	forDA = 0.02
}

ASSIGNED {
	v (mV)
	i (nA)
	tpost (ms)
}

STATE {
	g (uS)
	:numbre (1)
}

INITIAL {
	g=0.0:g=0.01 is not suitable
	tpost = -1e9
	net_send(0, 1)
	:numbre = 0
}

BREAKPOINT {
	SOLVE state METHOD cnexp
	i = g*(v - e)
	:numbre = numbre + 1
}

DERIVATIVE state {
	g' = -g/tau
	:g' = 1
	:numbre = numbre + 1
}

NET_RECEIVE(w (uS), tpre (ms)) {
    INITIAL { tpre = -1e9 }
    numbre = numbre + 1
    :printf("Enter in net receive section.\n")
    :printf("flag = %g, %g times \n",flag,numbre)
    if (flag == 0) { : presynaptic spike  (after last post so depress)
	:printf("from pre to post. %g\n", flag)
	:printf("before g = %g\n",g)
	:printf("the w to add is %g",w)
	g = g + w
	:printf("after g = %g\n",g)
	if(learning) {
	    :printf("enter the learning section.\n")
	    if (w>=minWeight){
		debug = tpost - t:LR*d*exp((tpost-t)/dtau)
		:printf("%g \n",debug)
		w = w-(1+forDA)*LR*d*exp((tpost - t)/dtau)
		:printf("after w = %g\n",w)
		if(w<=minWeight){
		    w=minWeight
		}
		:w = w*LR*d*(1-(exp((tpost - t)/dtau)))
		:if(verbose) {
		 :   printf("dep: w=%g \t dw=%g \t dt=%g\n", w, -LR*d*exp((tpost - t)/dtau), tpost-t)
		:}
	    }
	}
	tpre = t
    }else if (flag == 2) { : postsynaptic spike
	:printf("now is here(post to pre) %g \n",flag)
	tmp=forSpike
	if ( forSpike == 2){
	    :skip to change forSpike
	}else{
	    forSpike=1
	}
	
	:if(forSpike!=tmp){
	 :   printf("forSpike is changed!!\n")
	:}
	
	tpost = t
	FOR_NETCONS(w1,tp){
            if(learning) {
	:	printf("enter the learning section\n")
		if(w1<=maxWeight){
        	    
		    debug = LR*p*exp((tp-t)/ptau)
	:	    printf("%g \n",debug)
	            w1 = w1 + (1+forDA)*LR*p*exp((tp-t)/ptau):w1 = w1+LR*p*exp((tp - t)/ptau)
	:	    printf("after w1 = %g\n",w1)
		}
		if(w1>maxWeight){:if (w1>maxWeight){
	            w1=maxWeight:w1 = maxWeight
		}
	:	if(verbose) {
	 :           printf("pot: w=%g \t dw=%g \t dt=%g\n", w1, (LR*p*exp((tp - t)/ptau)), t - tp)
	:	}
	    }
	}
	
    } else { : flag == 1 from INITIAL block
	:printf("else section")
	WATCH (v > -20) 2
    }
}