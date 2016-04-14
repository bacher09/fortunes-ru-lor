DOWNLOAD_URL="http://lorquotes.ru/fortraw.php"
FILENAME=lor
VERSION=$(shell date +"%Y%m%d")
DIR_NAME=fortunes-ru-lor-${VERSION}
DEBIAN_FILES=$(shell find ./debian/ -type f)

.PHONY: clean package download

download: ${FILENAME}

${FILENAME}:
	curl ${DOWNLOAD_URL} | iconv -f koi8-r -t utf8 > ${FILENAME}

create_pkgdir: ${FILENAME} ${DEBIAN_FILES}
	if [ ! -d "${DIR_NAME}" ]; then mkdir "${DIR_NAME}"; fi
	if [ ! -d "${DIR_NAME}/debian/" ]; then mkdir "${DIR_NAME}/debian/"; fi
	cp -f "${FILENAME}" "${DIR_NAME}/"
	cp -rf debian/* "${DIR_NAME}/debian/"

package: create_pkgdir
	cd ${DIR_NAME} && debuild -us -uc -v${VERSION}

clean:
	@rm -f "${FILENAME}"
	@rm -rf "${DIR_NAME}"
	@rm -f fortunes-ru-lor_*
