# Copyright 2023 lmkra
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EGO_PN="github.com/showwin/speedtest-go"

inherit go-module

DESCRIPTION="Full-featured Command Line Interface and pure Go API to speedtest.net"
HOMEPAGE="https://github.com/showwin/speedtest-go"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/showwin/speedtest-go.git"
else
	SRC_URI="https://github.com/showwin/speedtest-go/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://lmkra.eu/gentoo/speedtest-go-${PV}-deps.tar.xz"
	S="${WORKDIR}/speedtest-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="dev-lang/go"
BDEPEND=""

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	ego build
}

src_install() {
	dobin speedtest-go
	dodoc -r examples
}
