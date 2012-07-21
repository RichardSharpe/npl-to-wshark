# Makefile for the NPL converter
#

CFLAGS = -g
CXXFLAGS = -g

test_driver: test_driver.o npl-scanner.o npl-to-wshark.o 
	$(CXX) -o test_driver test_driver.o npl-scanner.o npl-to-wshark.o -lm -lfl

npl-scanner.o:	npl-scanner.yy.h npl-scanner.yy.cpp npl-to-wshark.h
	$(CXX) -c -o npl-scanner.o npl-scanner.yy.cpp

npl-to-wshark.o: npl-to-wshark.cpp

npl-scanner.yy.cpp: flexfiles lemonfiles

npl-scanner.yy.h: flexfiles lemonfiles

npl-to-wshark.h: lemonfiles

.PHONY: flexfiles
flexfiles: npl-scanner.l
	flex --outfile=npl-scanner.yy.cpp --header-file=npl-scanner.yy.h npl-scanner.l

.PHONY: lemonfiles
lemonfiles: npl-to-wshark.y
	lemon npl-to-wshark.y -s
	mv npl-to-wshark.c npl-to-wshark.cpp

.PHONY: clean
clean:
	rm npl-to-wshark.cpp
	rm npl-to-wshark.out
	rm *.o
	rm test_driver
