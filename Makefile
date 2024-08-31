build:
	cd src && go build -o ../install ./main.go
	chmod +x ./install

install:
	make build
	./install

test:
	make build
	TEST=true DEBUG=true ./install
