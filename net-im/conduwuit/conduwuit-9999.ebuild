# Copyright 2023 lmkra
# Distributed under the terms of the GNU General Public License v3

EAPI=8

inherit cargo git-r3

DESCRIPTION="a very cool fork of Conduit, a Matrix homeserver written in Rust"
HOMEPAGE="https://github.com/girlbossceo/conduwuit"
EGIT_REPO_URI="https://github.com/girlbossceo/${PN}.git"
EGIT_BRANCH="main"

LICENSE="Apache-2.0"
SLOT="0"

S="${WORKDIR}/${P}"/src/main

IUSE="+brotli +element +gzip +io-uring jemalloc systemd +zstd debug"

RDEPEND="acct-user/matrix"
RDEPEND="
	acct-user/matrix
	!net-im/conduit
"
DEPEND="${RDEPEND}"
BDEPEND="
	llvm-core/clang
	>=dev-lang/rust-1.78.0:*
"
# skipped systemd support for now

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	local myfeatures=(
		media_thumbnail
		url_preview
		$(usev jemalloc)
		$(usev systemd)
		$(usev brotli brotli_compression)
		$(usev element element_hacks)
		$(usev gzip gzip_compression)
		$(usev io-uring io_uring)
		$(usev !debug release_max_log_level)
		$(usev zstd zstd_compression)
	)

	rust_pkg_setup
	cargo_src_configure --no-default-features --frozen
}

src_install() {
	cargo_src_install

	keepdir /var/{lib,log}/conduwuit
	fowners matrix:matrix /var/{lib,log}/conduwuit
	fperms 700 /var/{lib,log}/conduwuit

	newconfd "${FILESDIR}"/conduwuit.conf-r1 conduwuit
	newinitd "${FILESDIR}"/conduwuit.init-r2 conduwuit

	insinto /etc/conduwuit
	newins "${WORKDIR}/${P}"/conduwuit-example.toml conduwuit.toml

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/conduwuit.logrotate-r1 conduwuit
}

