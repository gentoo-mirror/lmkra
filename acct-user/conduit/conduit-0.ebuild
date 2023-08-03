# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for conduit Matrix server"
ACCT_USER_ID=601
ACCT_USER_GROUPS=( conduit )

acct-user_add_deps
