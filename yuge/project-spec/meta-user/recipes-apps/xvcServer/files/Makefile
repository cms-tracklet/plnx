APP = xvcServer

# Add any other object files to this list below
APP_OBJS = xvcServer.o

all: build 

build: $(APP)

$(APP): $(APP_OBJS)
	$(CC) $(LDFLAGS) -o $@ $(APP_OBJS) $(LDLIBS)

#install: $(APP)
#	$(TARGETINST) -d -p 0755 xvcServer.sh /etc/init.d/xvcServer.sh 
#	$(TARGETINST) -s /etc/init.d/xvcServer.sh /etc/rc5.d/S99xvcServer.sh 
#
clean:
	$(RM) $(APP_OBJS)
