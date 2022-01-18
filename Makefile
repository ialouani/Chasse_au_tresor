all: chasse.sh
	./chasse.sh
permission: chasse.sh
	chmod 777 chasse.sh 
clean:
	rm -f *.sh~ 44 Makefile~
