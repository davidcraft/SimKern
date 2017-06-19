#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jun 15 12:23:01 2017

@author: taylorsorenson
"""

from CellCyclefilereader import *

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
TotCdk = par['TotCdk']
TotCdc25  = par['TotCdc25']
TotWee1 = par['TotWee1']
TotIE = par['TotIE']
TotAPC = par['TotAPC']
PPase = par['PPase']

#Define rate coefficients
k25 = par["V25'"]*(TotCdc25-Cdc25P) + par['V25"']*Cdc25P
kwee = par["Vwee'"]*Wee1P + par['Vwee"']*(TotWee1-Wee1P)
k2 = par["V2'"]*(TotAPC-APC) + par['V2"']*APC
        
#Conservation Eqns:
Cdk = TotCdk - MPF - preMPF

#Setup differential equations
#d[something] represents d[something]/dt
dCyclin = par['k1']- k2*Cyclin - par['k3']*Cyclin*Cdk
dMPF = par['k3']*Cyclin*Cdk- k2*MPF - kwee*MPF + k25*preMPF
dpreMPF = kwee*MPF- k25*preMPF - k2*preMPF
dCdc25P = F(TotCdc25-Cdc25P,MPF,par['ka'],par['KKa']) \
           - F(Cdc25P,PPase,par['kb'],par['KKb'])
dWee1P = F(TotWee1-Wee1P,MPF,par['ke'],par['KKe']) \
          - F(Wee1P,PPase,par['kf'],par['KKf'])
dIEP = F(TotIE-IEP,MPF,par['kg'],par['KKg']) \
        - F(IEP,PPase,par['kh'],par['KKh'])
dAPC = F(TotAPC-APC,IEP,par['kc'],par['KKc']) \
        - F(APC,PPase,par['kd'],par['KKd'])
        
#Create matrix of concentrations of each node at each time step

#TODO - Create Function to go through one time step and update all concentrations

#TODO - Create Fn to go through all time steps until steady state is reached

#TODO - Define when steady state is reached
    #ie - when all concentrations stay the same after n time steps
    #or after concentrations fall within a small error after m time steps
    #etc - think about this more