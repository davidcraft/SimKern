#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Wed Jun 21 12:09:32 2017

@author: taylorsorenson
"""

import pysces
from pysces.PyscesInterfaces import Core2interfaces 
#pysces.test()


#mod = pysces.model('pysces_test_linear1.psc')
#exmod = pysces.model('pysces_test_branch1.psc')
##cell = pysces.model('isola2a.psc')
#
#
#
#mod.sim_start = 0.0
#mod.sim_end = 20
#mod.sim_points = 50
#mod.Simulate()
#mod.doState()
#
#exmod.sim_start = 0.0
#exmod.sim_end = 20
#exmod.sim_points = 50
#exmod.Simulate()
#exmod.doState()

#cell = pysces.model('pyscesexample.psc')


#Convert the senescene sbml file to psc file
core = Core2interfaces() #needed for first argument of Core2Interfaces
sen = Core2interfaces.convertSBML2PSC(core,'/Users/taylorsorenson/Desktop/MGH/DSPP/Pysces/inputs/sen1.xml', \
                                      pscfile = 'sen.psc')
