TITLE  Belmabrouk et al. 2011
:GPeA is changed based on Belmanbrouk et al. 2011
:
: Na+, K, Ca_T, Leakage, Ca diffusion, SK, and A(K)
: 



NEURON {
    SUFFIX GPeA
    NONSPECIFIC_CURRENT ilk
    USEION ca READ cai, cao WRITE ica, cai
    USEION k READ ki, ko WRITE ik
    USEION na READ nai, nao WRITE ina
    RANGE ina, ik, ica, iA
    RANGE gnabar, ena, m_inf, a_m, v_m, ena_fixed       : fast sodium
    RANGE gkdrbar, ek, W_inf,tau_W, ikD, lambda, sigma, a_W, v_W, ek_fixed               : delayed K rectifier
    RANGE gl, el, ilk                                    : leak
    RANGE gcatbar, eca, icaT, X, X_inf, tau_X, a_X, v_X : T-type ca current
    RANGE gkcabar, ek, ikAHP, Csk, q_inf, C_gamma, tau_sk, a_sk                      : ca dependent SK current
    RANGE kca, vol, caGain                               : ca dynamics
    RANGE A_inf, B, B_inf, tau_B, gA, a_A, a_B, v_A, v_B :A(K) leak current
}


UNITS {
    (mA) = (milliamp)
    (mV) = (millivolt)
    (S)  = (siemens)
    (molar) = (1/liter)
    (mM)	= (millimolar)
    (nM)        = (nanomolar)
    FARADAY = (faraday) (coulomb)  :units are really coulombs/mole
    PI	= (pi) (1)
}

PARAMETER {
    R = 8.31441 (Gas constant)
    T 		(Absolute temp)
    celsius		(degC)
    
    :Fast Na channel
    gnabar   = 120e-3 (S/cm2):49e-3 (S/cm2) 
    a_m = 0.065
    v_m = -31 (mV)
    ena_fixed = 55 (mV)
    : delayed K rectifier 
    gkdrbar  = 5e-3 (S/cm2):57e-3	(S/cm2)
    sigma = 1 (1)
    a_W = 0.055
    v_W = -46 (mV)
    ek_fixed = -70 (mV)
    lambda = 0.05 :the parameter of time constant here0.3 and init +10 ha antei
    :Leakage current
    gl	= 0.3e-3 (S/cm2):0.35e-3	(S/cm2)
    el	= -60	(mV)
    
    :Ca dynamics
    kca   = 2        (1/ms)
    area
    vol = 3.355e-11  (L) :~20um radius sphere
    caGain = .1
    
    :T-type ca current
    gcatbar   = 0.1e-3 (S/cm2):5e-3 (S/cm2)  
    tau_X = 50 (ms)
    a_X = 0.071
    v_X = -10 (mV)
    :AHP current (Ca dependent K current)
    gkcabar   = 2e-3 (S/cm2) :1e-3 (S/cm2) 
    C_gamma = 113(nM)
    tau_sk = 250 (ms)
    a_sk = 0.9 (1)
    :A(K)
    gA = 22e-3 (S/cm2)
    tau_B = 20 (ms)
    a_A = 0.02
    a_B = -0.1
    v_A = -20 (mV)
    v_B = -70 (mV)

}

ASSIGNED {
    v	(mV)
    ina	(mA/cm2)
    ik	(mA/cm2) 
    ikD	(mA/cm2)   
    ikAHP	(mA/cm2)  
    ica	(mA/cm2) 
    icaT	(mA/cm2) 
    ilk	(mA/cm2)
    iA      (mA/cm2)
    
    :Fast Na
    m_inf
    ena           (mV)   := 60
    
    :K rectifier
    W_inf
    tau_W	(ms)
    ek         (mV) := -90
    
    :T-type ca current
    eca           (mV)   :calc from Nernst
    X_inf
    :AHP (Ca dependent K current)
    q_inf (mM)
    :k
    A_inf
    B_inf
}

STATE {
    W 
    cai (mM) <1e-10>
    cao (mM) <1e-10>
    nai (mM) <1e-10>
    nao (mM) <1e-10>
    ki (mM) <1e-10>
    ko (mM) <1e-10>
    
    X
    Csk (nM) <1e-10>
    B
}


BREAKPOINT {
    SOLVE states METHOD cnexp
    
    T = 273 + celsius - 9.5
    :ena = -(R*T)/FARADAY*log(nai/nao)*1000
    :ek = (R*T)/FARADAY*log(ko/ki)*1000
    :eca = -(R*T)/FARADAY*log(cai/cao)*1000/2
    
    ina = gnabar * m_inf*m_inf*m_inf*(1-W) * (v - ena)
   
    ikD = gkdrbar * (W/sigma)^4 * (v - ek)
    ikAHP = gkcabar * (v - ek)*q_inf*q_inf
    iA = gA*A_inf*B*(v-ek)
    ik=ikD+ikAHP+iA
    ilk = gl * (v - el)
    ica = gcatbar*X*(v-eca)
    
}

DERIVATIVE states {   
    evaluate_fct(v)
    W' = (W_inf - W)/tau_W
    X' = (X_inf - X)/tau_X
    :(Ica mA/cm2)*(area um2)*(1e-8 cm2/um2)*(1e-3 A/mA)*(1/(2*F) mol/C)*(1e-3 sec/msec)*(1e3 mMol/mol)(1/volume 1/L)=(mM/msec)
    cai' = caGain*(-ica*area*1e-11/(2*FARADAY*vol) - kca*cai)
    Csk' = -a_sk*ica-(Csk-C_gamma)/tau_sk
    B' = (B_inf - B)/tau_B
}

UNITSOFF

INITIAL {
    evaluate_fct(v)
    W = W_inf   
    X = X_inf
    Csk = C_gamma +0.00001:when init is strange, here and lambda may have to be modified
    B = B_inf
}

PROCEDURE evaluate_fct(v(mV)) {     
    VERBATIM
    if(v>400){
	/*printf("too high v is investigated!!\n");
	/*printf("time is %lf, v = %lf\n",t,v);*/
	/*printf("too large v (v= %lf) is detected at t=%lf\n",v,t);*/
	/*sleep(1);*/
	/*printf("before v = %lf\n",v);*/
	/*v = -65;*/
	/*printf("after v = %lf \n",v);*/
    }else if(v<-250){
	/*printf("too small v (v= %lf) is detected at t = %lf\n",v,t);*/
	/*v = -65;*/
    }
    ENDVERBATIM
    :if((-2*a_m*(v-v_m))>700){
	:printf("here(m)  is the stopping point!!\n t = %g, v = %g(mV)\n",t,v)
:	m_inf = 1/(1+exp(700))
:    }else{
	m_inf = 1/(1+exp(-2*a_m*(v-v_m)))
:    }
:    if((-2*a_W*(v-v_W))>700){
:	printf("here(W)  is the stopping point!!\n t = %g, v = %g(mV)\n",t,v)
:	W_inf = 1/(1+exp(700))
:    }else{
	W_inf = 1/(1+exp(-2*a_W*(v-v_W)))
:    }
:    if(a_W*(v-v_W)>700){
	:	printf("tau is strange!!\n t = %g, v = %g\n",t,v)
:	tau_W = 1/(lambda*(exp(700)+exp(-a_W*(v-v_W))))
:    }else if(a_W*(v-v_W)<-700){
:	tau_W = 1/(lambda*(exp(a_W*(v-v_W))+exp(700)))
:    }else{
	tau_W = 1/(lambda*(exp(a_W*(v-v_W))+exp(-a_W*(v-v_W))))
:    }
   
    
:    if((-2*a_X*(v-v_X))>700){
:	printf("here(X)  is the stopping point!!\n t = %g, v = %g(mV)\n",t,v)
:	X_inf = 1/(1+exp(700))
:    }else{
	X_inf = 1/(1+exp(-2*a_X*(v-v_X)))
:    }
    if((Csk-C_gamma)<0.00001){
	Csk = C_gamma + 0.00001 :avoid that the argument in the log function is below 0
    }
    
    q_inf = 1/(1+exp(-1.120-2.508*log((Csk-C_gamma)/50)))
    
:    if((-2*a_A*(v-v_A))>700){
:	printf("here(A)  is the stopping point!!\n t = %g, v = %g(mV)\n",t,v)
:	A_inf = 1/(1+exp(700))
:    }else{
	A_inf = 1/(1+exp(-2*a_A*(v-v_A)))
:    }
:   if((-2*a_B*(v-v_B))>700){
:	printf("here(B)  is the stopping point!!\n t = %g, v = %g(mV)\n",t,v)
:	B_inf = 1/(1+exp(700))
:    }else{
	B_inf = 1/(1+exp(-2*a_B*(v-v_B)))
:    }
    :printf("log(10) = %g\n",log(10))
}

UNITSON