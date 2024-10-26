# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="A dead simple static HOMepage for your servER to keep your services on hand"
HOMEPAGE="https://github.com/bastienwirtz/homer"
SRC_URI="https://github.com/bastienwirtz/homer/releases/download/v${PV}/homer.zip -> homer-${PV}.zip"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

need_httpd

src_unpack() {
	mkdir -p "${WORKDIR}/${P}"
	cd "${WORKDIR}/${P}" && unpack ${A}
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_src_install
}
