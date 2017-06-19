#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 19 10:32:49 2017

@author: zdiamond
"""

class OdeSolver(object):
    
    import numpy as np
    
    def __init__(self,f):
        if not callable(f):
            raise TypeError('Not sufficient')
        self.f = lambda u, t: np.asarray(f(u,t))
        
    def set_initial_condition(self,U0):
        if isinstance(U0, (float,int)):
            self.neq = 1
        else:
            U0 = np.asarray(U0)
            self.neq = U0.size
        self.U0 = U0
        
    def solve(self,time_points):
        self.t = np.asarray(time_points)
        n = self.t.size
        if self.neq == 1:
            self.u = np.zeros(n)
        else:
            self.u = np.zeros((n.self.neq))
        
        self.u[0] = self.U0
        
        for k in range (n-1):
            self.k = k
            self.u[k+1] = self.advance()
        return self.u, self.t
    
    def advance(self):
        u, f, k, t = self.u, self.f, self.k, self.t
        dt = t[k+1]-t[k]
        u_new = u[k] + dt*f(u[k],t[k])
        return u_new
    
def f(u,t):
    return u

solver = OdeSolver(f)
solver.set_initial_condition(1.0)
tp = np.linspace(0,5,100)
u,t = solver.solve(tp)
plot(t,u)