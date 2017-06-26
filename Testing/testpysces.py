#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 21 12:09:32 2017

@author: taylorsorenson
"""
#==============================================================================
# NOTE - Pysces MUST be run using Python 2.7
#==============================================================================

import pysces
from pysces.PyscesInterfaces import Core2interfaces 
from pysces.PyscesModel import StateDataObj
from pysces.PyscesModel import IntegrationDataObj
#pysces.test()

#Convert the senescene sbml file to psc file
def convert(sbml_file,psc_output):
    '''
    Takes in the location of an smbl_file (usually denoted with .xml) and
    creates a new psc file in the defined lcoation psc_output
    Ex: smbl_file = /Users/taylorsorenson/Inputs/cellcycle.xml
        psc_output = /Users/taylorsorenson/Pysces/pyc/cellcycle.psc
    '''
    core = Core2interfaces() #needed for first argument of Core2Interfaces
    Core2interfaces.convertSBML2PSC(core, sbml_file, pscfile = psc_output)

def sim_plot(pscfilename, end_time, plot=True):
    '''
    Takes in a psc file, creates a pysces model, finds the steady states,
    and plots the values of each Species concentration over time
    Also takes in plot arg - input True if a plot is desired, False if the plot
    is NOT desired
    Returns : a model object
    '''
    model = pysces.model(pscfilename)
    model.p21 = 13.123456
    model.sim_start = 0.0
    model.sim_end = 20
    model.sim_points = 50
    model.Simulate()
    model.doState()
    if plot:
        model.doSimPlot(end=end_time,points=end_time*10,plot='species', fmt='lines',filename = None)
    else:
        pass
    return model

#s1_mod = pysces.model('sen2.psc')
#s1_mod.sim_start = 0.0
#s1_mod.sim_end = 20
#s1_mod.sim_points = 50
#s1_mod.Simulate()
#s1_mod.doState()
#s1_mod.doSimPlot(end=10.0,points=2100,plot='species', fmt='lines',filename = None)


#s2_mod = pysces.model('2sen.psc')
#s2_mod.sim_start = 0.0
#s2_mod.sim_end = 20
#s2_mod.sim_points = 50
#s2_mod.Simulate()
#s2_mod.doState()
#s2_mod.doSimPlot(end=10.0,points=210,plot='species', fmt='lines',filename = None)


#cc1_mod = pysces.model('cellcycle1.psc')
#cc1_mod.sim_start = 0.0
#cc1_mod.sim_end = 20
#cc1_mod.sim_points = 50
#cc1_mod.Simulate()
#cc1_mod.doState()
#cc1_mod.doSimPlot(end=10.0,points=210,plot='species', fmt='lines',filename = None)

#cc2_mod = pysces.model('cellcycle2.psc')
#cc2_mod.sim_start = 0.0
#cc2_mod.sim_end = 20
#cc2_mod.sim_points = 50
#cc2_mod.Simulate()
#cc2_mod.doState()
#cc2_mod.doSimPlot(end=10.0,points=210,plot='species', fmt='lines',filename = None)


#convert('/Users/taylorsorenson/inputs/apop243.xml','apop243.psc')
#convert('/Users/taylorsorenson/inputs/apop005.xml','apop005.psc')

#Simulate Apoptosis Models
#apop2 = sim_plot('apop243.psc')
#apop5 = sim_plot('apop005.psc')

#Simulate Senescene Models
#sen2 = sim_plot('sen1.psc', 10, plot=True)
#sen3 = sim_plot('sen2.psc')
sen3_mod = sim_plot('2sen.psc', 10, plot=True)

#Simulate Cell Cycle Models
#cc1 = sim_plot('cellcycle1.psc')
#cc2 = sim_plot('cellcycle2.psc')
