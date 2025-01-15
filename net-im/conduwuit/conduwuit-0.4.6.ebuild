EAPI=8

inherit cargo

DESCRIPTION="a very cool fork of Conduit, a Matrix homeserver written in Rust"
HOMEPAGE="https://github.com/girlbossceo/conduwuit"
SRC_URI="
	https://github.com/girlbossceo/conduwuit/archive/refs/tags/v${PV}.tar.gz
	https://lmkra.eu/gentoo/${P}-deps.tar.xz
"

S="${WORKDIR}/${P}/src/main"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="+brotli +element +gzip +io-uring jemalloc systemd +zstd debug"

DEPEND=""
RDEPEND="
	acct-user/matrix
	!net-im/conduit
"
BDEPEND="
	llvm-core/clang
	>=dev-lang/rust-1.78.0:*
"

# rust does not use *FLAGS from make.conf, silence portage warning
# update with proper path to binaries this crate installs, omit leading /
QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	ln -s "${WORKDIR}/vendor/" "${WORKDIR}/conduwuit-${PV}/vendor" || die

	sed -i "${ECARGO_HOME}/config.toml" -e '/source.crates-io/d'  || die
	sed -i "${ECARGO_HOME}/config.toml" -e '/replace-with = "gentoo"/d'  || die
	sed -i "${ECARGO_HOME}/config.toml" -e '/local-registry = "\/nonexistent"/d'  || die

	cat "${WORKDIR}/vendor/vendor-config.toml" >> "${ECARGO_HOME}/config.toml" || die

	eapply_user
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
	newinitd "${FILESDIR}"/conduwuit.init-r1 conduwuit

	insinto /etc/conduwuit
	newins "${WORKDIR}/${P}"/conduwuit-example.toml conduwuit.toml

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/conduwuit.logrotate-r1 conduwuit
}
