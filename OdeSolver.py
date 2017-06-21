#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 19 10:32:49 2017

@author: zdiamond zhaoqi wang
"""
#Solves scalar and vector 1st order ODEs by Forward Euler's Method. 
import matplotlib.pyplot as plt
import numpy as np


class OdeSolver(object):
        
    def __init__(self,f):
        '''
        t is a 1-d array of time step values
        u is an array of solutio values a time points t
        k is the step number
        f is a callable object implementing f(u,t)
        '''
        if not callable(f):
            raise TypeError('Not sufficient')
        self.f = lambda u, t: np.asarray(f(u,t))
        
    def set_initial_condition(self,U0):
        if isinstance(U0, (float,int)):
            self.neq = 1 #Scalar/One ODE
        else:
            U0 = np.asarray(U0) #Vector/System of ODEs
            self.neq = U0.size
        self.U0 = U0
        
    def solve(self,time_points):
        self.t = np.asarray(time_points)
        n = self.t.size #number of time steps
        if self.neq == 1: #Scalar
            self.u = np.zeros(n)
        else:
            self.u = np.zeros((n,self.neq)) #Vector - 2dm matrix
        
        self.u[0] = self.U0 #make first entry the initial conditions
        
        for k in range (n-1):
            self.k = k
            self.u[k+1] = self.advance()
        return self.u, self.t
    
    def advance(self):
        u, f, k, t = self.u, self.f, self.k, self.t
        dt = t[k+1]-t[k]
        u_new = u[k] + dt*f(u[k],t[k])
        return u_new
    
#def f0(u,t):
#    return u*t
#
#def f1(u,t):
#    return u + t
#
#def f2(u,t):
#    return u**2 + t**2
#
#f = f0
#solver = OdeSolver(f)
#solver.set_initial_condition(np.array([1.0,2.0,3.0]))
#tp = np.linspace(0,5,100)
#u,t = solver.solve(tp)
#print(u)
