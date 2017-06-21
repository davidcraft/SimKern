#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 15 12:23:01 2017

@author: taylorsorenson
"""

from CellCyclefilereader import *
from OdeSolver import *
from scipy.integrate import odeint
import matplotlib.pyplot as plt

def F(S,E,k,Km):
    ''' Rewrites using Michaelis-Mentin Kinetics
    '''
    return k*E*S/(Km + S)

par = read_parameters('cellcycleparameters.rtf')
i = read_parameters('ccinitcond.rtf')

#Set Init Conditions
Cyclin, MPF, preMPF, Cdc25P, Wee1P, IEP, APC = i['\\fs18 Cyclin'], i['MPF'],\
                                                i['preMPF'], i['Cdc25P'], \
                                                 i['Wee1P'], i['IEP'], i['APC']
#Set other parameters, also read in from text file
#Note that these parameters will not change
TotCdk = par['TotCdk']
TotCdc25  = par['TotCdc25']
TotWee1 = par['TotWee1']
TotIE = par['TotIE']
TotAPC = par['TotAPC']
PPase = par['PPase'] #excpet maybe PPase - not too sure on this one

#Define rate coefficients - Assume to be constant and not changing in time
k25 = par["V25'"]*(TotCdc25-Cdc25P) + par['V25"']*Cdc25P
kwee = par["Vwee'"]*Wee1P + par['Vwee"']*(TotWee1-Wee1P)
k2 = par["V2'"]*(TotAPC-APC) + par['V2"']*APC
        
#Conservation Eqns:
Cdk = TotCdk - MPF - preMPF #TODO - move to after ODE'S 

#Setup differential equations
#d[something] represents d[something]/dt
dCyclin = lambda Cyclin,Cdk: par['k1']- k2*Cyclin - par['k3']*Cyclin*Cdk
dMPF = lambda Cyclin, Cdk, MPF, preMPF: par['k3']*Cyclin*Cdk- k2*MPF - kwee*MPF + k25*preMPF
dpreMPF = lambda MPF,preMPF: kwee*MPF- k25*preMPF - k2*preMPF
dCdc25P = lambda Cdc25P,MPF: F(TotCdc25-Cdc25P,MPF,par['ka'],par['KKa']) \
           - F(Cdc25P,PPase,par['kb'],par['KKb'])
dWee1P = lambda Wee1P,MPF: F(TotWee1-Wee1P,MPF,par['ke'],par['KKe']) \
          - F(Wee1P,PPase,par['kf'],par['KKf'])
dIEP = lambda IEP,MPF: F(TotIE-IEP,MPF,par['kg'],par['KKg']) \
        - F(IEP,PPase,par['kh'],par['KKh'])
dAPC = lambda APC,IEP: F(TotAPC-APC,IEP,par['kc'],par['KKc']) \
        - F(APC,PPase,par['kd'],par['KKd'])
 

U0 = np.array((Cyclin,Cdk,MPF,preMPF,Cdc25P,Wee1P,IEP,APC))  

def f(u,t):
    '''
    u is a 1D array of the protein concentrations at the previous time step
    t is a 1D list of all time steps
    '''    
    #Initialize all the variable names
    Cyclin,Cdk,MPF,preMPF,Cdc25P,Wee1P,IEP,APC = tuple(u)
    #Return an array of the same length as u, representing the differential
    #amount each protein in u will change
    return np.array((dCyclin(Cyclin,Cdk), \
                     0, #represents Cdk - treat differently from other differentials
                     dMPF(Cyclin,Cdk,MPF,preMPF), \
                         dpreMPF(MPF,preMPF),\
                                dCdc25P(Cdc25P,MPF,),\
                                       dWee1P(Wee1P,MPF),\
                                             dIEP(IEP,MPF),\
                                                 dAPC(APC,IEP)))
#Solve using OdeSolver module
#cellsolver = ODESolver(f)
#cellsolver.set_initial_condition(U0)
times = np.linspace(0,100,5000000)
#u,t = cellsolver.solve(times)


#Solve using Scipy numerical solver:
sol = odeint(f,U0,times)
#print(sol)

plt.figure()
plt.plot(times,sol[:,7])


#Create matrix of concentrations of each node at each time step

#TODO - Create Function to go through one time step and update all concentrations

#TODO - Create Fn to go through all time steps until steady state is reached

#TODO - Define when steady state is reached
    #ie - when all concentrations stay the same after n time steps
    #or after concentrations fall within a small error after m time steps
    #etc - think about this more