def reg
def gp8x32 is reg
def gp16x32 is reg

def arch
def __any is arch
def __x32 is __any
def __x64 is __any

instance gp8x32  al,bl,cl,dl,ah,bh,ch,dh
instance gp16x32 ax,bx,cx,dx,si,di,sp,bp

__x32 func1(gp8x32 param1) {
    gp16x32    local1
    mov        local1,param1
    add        param1,local1
}

__x32 func1(gp16x32 param1) {
    gp16x32    local1
    mov        local1,param1
    add        param1,local1
}

add          bx,cx
func1        ch
gp16x32      g1
func1        g1