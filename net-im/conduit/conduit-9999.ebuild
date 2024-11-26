# Copyright 2023 lmkra
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit cargo git-r3 rust

DESCRIPTION="Matrix homeserver written in Rust"
HOMEPAGE="https://gitlab.com/famedly/conduit"
EGIT_REPO_URI="https://gitlab.com/famedly/${PN}.git"
EGIT_BRANCH="next"

LICENSE="Apache-2.0"
SLOT="0"

# aligned with default_features from Cargo.toml
# skipped systemd support for now
IUSE="jemalloc +rocksdb +sqlite"

RDEPEND="acct-user/matrix"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/clang
	>=dev-lang/rust-1.78.0
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	local myfeatures=(
		conduit_bin
		$(usev jemalloc)
	)

	if use rocksdb ; then
		myfeatures+=('backend_rocksdb')
	fi

	if use sqlite ; then
		myfeatures+=('backend_sqlite')
	fi

	rust_pkg_setup
	cargo_src_configure --frozen --no-default-features
}

src_install() {
	cargo_src_install

	keepdir /var/{lib,log}/conduit
	fowners matrix:matrix /var/{lib,log}/conduit
	fperms 700 /var/{lib,log}/conduit

	newconfd "${FILESDIR}"/conduit.conf-r1 conduit
	newinitd "${FILESDIR}"/conduit.init-r1 conduit

	insinto /etc/conduit
	newins conduit-example.toml conduit.toml

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/conduit.logrotate-r1 conduit
}
