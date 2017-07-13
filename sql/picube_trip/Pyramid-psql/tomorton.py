def tomorton(x,y):
    x = bin(x)[2:]
    lx = len(x)
    y = bin(y)[2:]
    ly = len(y)
    L = max(lx, ly)
    m = 0
    for j in range(1, L+1):
        # note: ith bit of x requires x[lx - i] since our bin numbers are big endian
        xi = int(x[lx-j]) if j-1 < lx else 0
        yi = int(y[ly-j]) if j-1 < ly else 0
        m += 2**(2*j)*xi + 2**(2*j+1)*yi
    return m/4
