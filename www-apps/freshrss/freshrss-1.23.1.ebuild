# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="FreshRSS is a self-hosted RSS feed aggregator"
HOMEPAGE="https://freshrss.org"
SRC_URI="https://github.com/freshrss/freshrss/archive/refs/tags/${PV}.tar.gz -> freshrss-${PV}.tar.gz"

S="${WORKDIR}/FreshRSS-${PV}"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="gmp
	iconv
	mysql
	postgres
	sqlite
	zip
	zlib
	"

RDEPEND="dev-lang/php[gmp?,iconv?,mysql?,pdo,postgres?,sqlite?,zip?,zlib?]
	virtual/httpd-php"

need_httpd_cgi

src_prepare() {
	rm Makefile

	eapply_user
}

src_install() {
	webapp_src_preinst

	rm LICENSE.txt CHANGELOG*.md CONTRIBUTING.md CREDITS.md || die
	rm -rf Docker tests || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}/data"

	webapp_src_install
}
