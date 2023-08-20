# Copyright 2023 lmkra
# Distributed under the terms of the GNU General Public License v3

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="A Matrix-Facebook Messenger puppeting bridge"
HOMEPAGE="https://github.com/mautrix/facebook"
SRC_URI="https://github.com/mautrix/facebook/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/facebook-${PV}"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	net-im/mautrix-common
	>=dev-db/postgresql-10.0:*
	media-video/ffmpeg
	=dev-python/aiohttp-3*[${PYTHON_USEDEP}]
	>=dev-python/asyncpg-0.20[${PYTHON_USEDEP}]
	<dev-python/asyncpg-0.28[${PYTHON_USEDEP}]
	>=dev-python/commonmark-0.8[${PYTHON_USEDEP}]
	<dev-python/commonmark-0.10[${PYTHON_USEDEP}]
	=dev-python/python-magic-0.4*[${PYTHON_USEDEP}]
	=dev-python/yarl-1*[${PYTHON_USEDEP}]
	>=dev-python/mautrix-0.19.6[${PYTHON_USEDEP}]
	<dev-python/mautrix-0.20[${PYTHON_USEDEP}]
	=dev-python/pycryptodome-3*[${PYTHON_USEDEP}]
	>=dev-python/paho-mqtt-1.5.0[${PYTHON_USEDEP}]
	<dev-python/paho-mqtt-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.94[${PYTHON_USEDEP}]
	<dev-python/ruamel-yaml-0.18[${PYTHON_USEDEP}]
	dev-python/zstandard[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
BDEPEND=""

src_prepare() {
	sed -i '/example-config.yaml/d' setup.py || die "Sed failed"
	distutils-r1_python_prepare_all
}

src_install() {
	insinto /etc/mautrix/facebook
	newins mautrix_facebook/example-config.yaml config.yaml
	doins mautrix_facebook/example-config.yaml
	fowners matrix:matrix /etc/mautrix/facebook/config.yaml
	fperms 644 /etc/mautrix/facebook/config.yaml /etc/mautrix/facebook/example-config.yaml

	newbin "${FILESDIR}"/mautrix-facebook.bin-r1 mautrix-facebook
	newconfd "${FILESDIR}"/mautrix-facebook.conf-r1 mautrix-facebook
	newinitd "${FILESDIR}"/mautrix-facebook.init-r1 mautrix-facebook

	docompress -x /usr/share/doc/${PF}/example-config.yaml

	dodoc mautrix_facebook/example-config.yaml

	distutils-r1_src_install
}

distutils_enable_tests pytest
