COMMENT
Since this is an electrode current, positive values of i depolarize the cell
and in the presence of the extracellular mechanism there will be a change
in vext since i is not a transmembrane current but a current injected
directly to the inside of the cell.
ENDCOMMENT

NEURON {
    POINT_PROCESS GammaNoise
    RANGE del, dur, amp, i, R, forRand, forRand2, k, n, tmp_n, THETA, KAPPA, int_kappa, frac_kappa, b, p, x_frac, x_int, roop, i_max, i_min, times, ave_v
    ELECTRODE_CURRENT i
}
UNITS {
    (nA) = (nanoamp)
    (mV) = (millivolt)
}

PARAMETER {
    del (ms)
    dur (ms)	<0,1e9>
    amp (nA)
    R = 200
    forRand = 0.01
    forRand2 = 0.01
    k = 0 :counter
    n = 2.7 :parameter to adjust
    tmp_n = 1
    THETA = 0.012:1.05 :parameter(sita no to awase te 3Hz kurai)
    KAPPA = 0.11:0.01:parameter
    int_kappa = 1
    frac_kappa = 0
    b = 1
    p = 1
    x_frac = 0
    x_int = 1
    roop = 0
    i_max = -100
    i_min = 100
    times = 0
    ave_v = 0
}
ASSIGNED { i (nA) 
    v (mV)
}

INITIAL {
    i = 0
    VERBATIM
    srand((unsigned)time(NULL));
    /*srand(25525);*/
    ENDVERBATIM
}


BREAKPOINT {
    
    at_time(del)
    at_time(del+dur)
    VERBATIM
    int_kappa = (int)KAPPA;
    frac_kappa = KAPPA - (double)int_kappa;
    forRand = ((double)(rand()+1.0))/((double)RAND_MAX+2.0);
    x_int = 0;
    for(roop=0;roop<int_kappa;roop++){
	x_int += -log(forRand);
    }
    if(fabs(frac_kappa)<0.01){ x_frac=0; }
    else{
	b = (exp(1.0)+frac_kappa)/exp(1.0);
	while(1){
	    forRand = ((double)(rand()+1.0))/((double)RAND_MAX+2.0);
	    p = b*forRand;
	    forRand2 = ((double)(rand()+1.0))/((double)RAND_MAX+2.0);
	    if(p<=1.0){
		x_frac = pow(p,1.0/frac_kappa);
		if(forRand2<=exp(-x_frac)){break;}
	    }else{
		x_frac = -log((b-p)/frac_kappa);
		if(forRand2<=pow(x_frac,frac_kappa-1.0)){
		    break;
		}
	    }
	}
    }
    amp = THETA*(x_frac+x_int);
    ENDVERBATIM
    :printf("amp = %g\n",amp)

    if (t < del + dur && t >= del) {
	i = amp
	:printf("i = %g (nA)\n",i)
	if(i>i_max){
	    i_max = i
	    VERBATIM
	    usleep(1);
	    ENDVERBATIM
	}
	if(i<i_min){
	    i_min = i
	    VERBATIM
	    usleep(1);
	    ENDVERBATIM
	}
	:printf("i_max = %g\t i_min = %g\n",i_max,i_min)
    }else{
	i = 0
    }
    times = times + 1
    ave_v = ave_v + v
    :printf("current average of voltage is %g\n",ave_v/times)
    
}
