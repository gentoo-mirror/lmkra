# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for all Matrix-related daemons"
ACCT_USER_ID=601
ACCT_USER_GROUPS=( matrix )

acct-user_add_deps
