-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.admin.index", package.seeall)

function index()
	-- Empty services menu to be populated by addons
	entry({"admin"}, firstchild(), _("Services"), 40).index = true
	entry({"admin", "services"}, firstchild(), _("Services"), 40).index = true

	entry({"admin", "logout"}, call("action_logout"), _("Logout"), 90)
end

function action_logout()
	local dsp = require "luci.dispatcher"
	local utl = require "luci.util"
	local sid = dsp.context.authsession

	if sid then
		utl.ubus("session", "destroy", { ubus_rpc_session = sid })

		luci.http.header("Set-Cookie", "sysauth=%s; expires=%s; path=%s/" %{
			sid, 'Thu, 01 Jan 1970 01:00:00 GMT', dsp.build_url()
		})
	end

	luci.http.redirect(dsp.build_url())
end
