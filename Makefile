# makefile for pack library for Lua

# change these to reflect your Lua installation
# LUA=$(word 1,$(shell which lua5.1$(_LUAEXT)) $(shell which lua51$(_LUAEXT)) lua$(_LUAEXT))
LUA=~/temp/lede/build_dir/hostpkg/lua-5.1.5/src1
LUAINC= $(LUA)/src1
LUALIB= $(LUA)/src1
LUABIN= $(LUA)/src1

# probably no need to change anything below here
CFLAGS= $(INCS) $(WARN) -O2 $G
WARN= -ansi -pedantic -Wall
INCS= -I$(LUAINC)

MYNAME= pack
MYLIB= l$(MYNAME)
T= $(MYNAME).so
OBJS= $(MYLIB).o
TEST= test.lua

all:	test

test:	$T
	$(LUABIN)/lua $(TEST)

o:	$(MYLIB).o

so:	$T

$T:	$(OBJS)
	$(CC) -o $@ -shared $(OBJS)

clean:
	rm -f $(OBJS) $T core core.* a.out

doc:
	@echo "$(MYNAME) library:"
	@fgrep '/**' $(MYLIB).c | cut -f2 -d/ | tr -d '*' | sort | column

# distribution

FTP= $(HOME)/public/ftp/lua/5.1
D= $(MYNAME)
A= $(MYLIB).tar.gz
TOTAR= Makefile,README,$(MYLIB).c,test.lua

tar:	clean
	tar zcvf $A -C .. $D/{$(TOTAR)}

distr:	tar
	touch -r $A .stamp
	mv $A $(FTP)

diff:	clean
	tar zxf $(FTP)/$A
	diff $D .

# eof
