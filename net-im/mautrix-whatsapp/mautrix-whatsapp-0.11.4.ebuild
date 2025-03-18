# Copyright 2023 lmkra
# Distributed under the terms of the GNU General Public License v2

EAPI=8
EGO_PN="github.com/mautrix/whatsapp"

inherit go-module

DESCRIPTION="A Matrix-WhatsApp puppeting bridge based on whatsmeow."
HOMEPAGE="https://github.com/mautrix/whatsapp"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mautrix/whatsapp.git"
else
	SRC_URI="https://github.com/mautrix/whatsapp/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
		https://lmkra.eu/gentoo/mautrix-whatsapp-${PV}-deps.tar.xz"
	S="${WORKDIR}/whatsapp-${PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="AGPL-3"
SLOT="0"

RDEPEND="net-im/mautrix-common
	dev-libs/olm
	acct-user/matrix
	>=dev-db/postgresql-10.0:*
	media-video/ffmpeg"
DEPEND="dev-lang/go
${RDEPEND}"

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		git-r3_src_unpack
		go-module_live_vendor
	else
		go-module_src_unpack
	fi
}

src_compile() {
	ego build ./cmd/mautrix-whatsapp
	einfo "Generating example config"
	./mautrix-whatsapp -e
}

src_install() {
	newconfd "${FILESDIR}"/mautrix-whatsapp.conf-r1 mautrix-whatsapp
	newinitd "${FILESDIR}"/mautrix-whatsapp.init-r1 mautrix-whatsapp

	dobin mautrix-whatsapp
	insinto /etc/mautrix/whatsapp
	doins config.yaml
	fowners matrix:matrix /etc/mautrix/whatsapp/config.yaml
	fperms 644 /etc/mautrix/whatsapp/config.yaml

	newdoc config.yaml example-config.yaml
	docompress -x /usr/share/doc/${PF}/example-config.yaml
}
