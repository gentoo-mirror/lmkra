# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..12} )

inherit distutils-r1

DESCRIPTION="A Python 3.8+ asyncio Matrix framework"
HOMEPAGE="https://github.com/mautrix/python"
SRC_URI="https://github.com/mautrix/python/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/python-${PV}"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/aiohttp
	dev-python/attrs
	dev-python/yarl
"
BDEPEND="
"

distutils_enable_tests pytest
