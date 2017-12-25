def reg
def gp8x32 is reg
def gp16x32 is reg

def arch
def __any is arch
def __x32 is __any
def __x64 is __any
target al,bl,cl,dl,ah,bh,ch,dh is gp8x32
target ax,bx,cx,dx,si,di,sp,bp is gp16x32

def mem

rule __x32 !__x64
rule __x64 !__x32
rule al !ah & !ax

__x32 func1(gp8x32 param1) code {
    gp16x32    local1
    mov        local1,param1
    add        param1,local1
}
rule func1(gp8x32) __x32

__x32 func1(gp16x32 param1) code {
    gp16x32    local1
    mov        local1,param1
    add        param1,local1
}

__x32 func1(reg param1) code {
    gp16x32    local1
    mov        local1,param1
    add        param1,local1
}

__x32 operator +(imm) code {
}

add          bx,cx
func1        ch
gp16x32      g1
func1        g1