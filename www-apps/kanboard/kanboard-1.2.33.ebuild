# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Kanboard is a free and open source Kanban project management software"
HOMEPAGE="https://kanboard.org"
SRC_URI="https://github.com/kanboard/kanboard/archive/refs/tags/v${PV}.tar.gz -> kanboard-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
IUSE="curl
	mysql
	ldap
	postgres
	sqlite
	zip
	"

RDEPEND="dev-lang/php[ctype,curl?,filter,gd,mysql?,ldap?,pdo,postgres?,session,simplexml,sqlite?,ssl,xml,zip?]
	virtual/httpd-php"

need_httpd_cgi

src_install() {
	webapp_src_preinst

	rm LICENSE || die

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}/data"

	webapp_src_install
}
