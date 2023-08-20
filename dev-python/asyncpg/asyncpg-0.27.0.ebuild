# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{7..12} )

inherit distutils-r1 git-r3

DESCRIPTION="database library for PostgreSQL and asyncio"
HOMEPAGE="https://github.com/MagicStack/asyncpg"

# Using git tag instead of release tarball due to git submodule required for successful build
EGIT_REPO_URI="https://github.com/MagicStack/${PN}.git"
EGIT_COMMIT="v${PV}"

DISTUTILS_EXT=1

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
