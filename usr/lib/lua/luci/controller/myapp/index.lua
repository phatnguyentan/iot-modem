-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.myapp.index", package.seeall)

function index()
	local root = node()
	if not root.target then
		root.target = alias("myapp")
		root.index = true
	end

	local page   = node("myapp")
	page.target  = firstchild()
	page.title   = _("Administration")
	page.order   = 10
	page.sysauth = "root"
	page.sysauth_authenticator = "htmlauth"
	page.ucidata = true
	page.index = true
	entry({"myapp"}, template("myapp-mymodule/helloworld")).index=true
end