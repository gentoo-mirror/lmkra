# Copyright 2023 lmkra
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Common parts of Mautrix bridges"
HOMEPAGE="https://github.com/mautrix"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="acct-user/matrix"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}

src_install() {
		keepdir /var/log/mautrix
		fowners matrix:matrix /var/log/mautrix
		fperms 700 /var/log/mautrix

		keepdir /etc/mautrix

		#insinto /etc/logrotate.d
		#newins "${FILESDIR}"/mautrix.logrotate-r1 mautrix
}
