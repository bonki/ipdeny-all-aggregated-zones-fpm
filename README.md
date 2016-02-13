Downloads all aggregated country zone files from http://ipdeny.com/ and uses `fpm` to build a `deb`/`rpm` package.

	# optionally, install required dependencies (ruby, fpm)
	$ make depinstall

	# build a package for the local system (.deb/.rpm)
	$ make

	# install the newly generated package
	$ make install

