default: clean build package
clean:
	rm -rf vendor
	rm -rf airdrop.tar airdrop.tar.gz

build:
	mkdir vendor
	docker build -t airdrop .
	#docker run -v `pwd`:/airdrop airdrop bundle install --path vendor/bundle
	docker run -v `pwd`:/airdrop airdrop bundle package

package:
	tar -cvf airdrop.tar *
	gzip airdrop.tar
