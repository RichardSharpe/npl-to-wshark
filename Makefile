# Makefile for the NPL converter
#


.PHONY: lemonfiles clean

lemonfiles: npl-to-wshark.y
	lemon npl-to-wshark.y -s
	mv npl-to-wshark.c npl-to-wshark.cpp

clean:
	rm npl-to-wshark.cpp
	rm npl-to-wshark.out
