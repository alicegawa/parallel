import numpy as np

a = np.loadtxt('con_var_out1.dat')
b = a[0,:]
print a
print b

c = b.sum()
print c

print len(a), len(a[0])
max_c = 0
max_index = -1
for i in range(0,len(a)-1):
    b = a[i,:]
    c = b.sum()
    if c>max_c :
        max_c = c
        max_index = i

print max_c
#print max_index

max_c = 0
a = np.loadtxt('con_var_out2.dat')
for i in range(0,len(a)-1) :
    b = a[i,:]
    c = b.sum()
    if c > max_c :
        max_c = c
        max_index = i

print max_c



max_c = 0
a = np.loadtxt('con_var_i2o1.dat')
for i in range(0,len(a)-1) :
    b = a[i,:]
    c = b.sum()
    if c > max_c :
        max_c = c
        max_index = i

print max_c

max_c = 0
a = np.loadtxt('con_var_i2o2.dat')
for i in range(0,len(a)-1) :
    b = a[i,:]
    c = b.sum()
    if c > max_c :
        max_c = c
        max_index = i

print max_c



