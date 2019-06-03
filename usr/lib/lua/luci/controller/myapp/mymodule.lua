module("luci.controller.myapp.mymodule", package.seeall)

function index()
    entry({"my", "new", "template"}, template("myapp-mymodule/helloworld"), "Hello world", 20).dependent=false
    entry({"my", "new", "background"}, template("myapp-mymodule/helloworld"), "Hello world", 20).dependent=false
		entry({"my", "new", "upload"}, call("uploader")).dependent=false
		entry({"my", "new", "fanpage"}, template("myapp-mymodule/fanpage")).dependent=false
		entry({"my", "update", "page"}, call("copy_config")).dependent=false

		entry({"my", "status", "realtime", "connections"}, template("myapp-mymodule/connections"), _("Connections"), 4).dependent=false
end

function uploader()
   local error = nil	
   --add your defaults (file_name is optional btw)
   file_loc = "/etc/nodogsplash/htdocs/images/"
   input_field = "archive"
   file_name = "default"
   local http = require "luci.http"
   --actually call the file handler
   --get the values from the forms on the page
   local values = luci.http.formvalue()
   --get the value of the input field
   local ul = values[input_field]
   --make sure something is being uploaded
   if ul ~= '' and ul ~= nil then
	  --Start your uploader
	  setFileHandler(file_loc, input_field, file_name)
	  --Run whatever check you need against the file to make sure it is
    -- accurate. Return nil if all is ok. (this function not included in this
    -- mini-tutorial)
	  -- error = checkFile(file_loc)
   end
  --  luci.template.render("admin/uploader", {error=error})
   http.redirect(luci.dispatcher.build_url('my/new/template'))
end

function setFileHandler(location, input_name, file_name)
	  local sys = require "luci.sys"
	  local fs = require "nixio.fs"
	  local fp
	  luci.http.setfilehandler(
		 function(meta, chunk, eof)
		 if not fp then
			--make sure the field name is the one we want
			if meta and meta.name == input_name then
			   --use the file name if specified
			   if file_name ~= nil then
				  fp = io.open(location .. file_name, "w")
			   else
				  fp = io.open(location .. meta.file, "w")
			   end
			end
		 end
		 --actually do the uploading.
		 if chunk then
			fp:write(chunk)
		 end
		 if eof then
			fp:close()
		 end
		 end)
end

function copy_config()
	local http = require "luci.http"
	local values = luci.http.formvalue()
	local link = values["link"]
	local infile = io.open("/usr/lib/lua/luci/controller/myapp/nodogsplash.conf", "r")
	local instr = infile:read("*a")
	infile:close()

	instr = string.gsub(instr, "redirect_url", link)

	local outfile = io.open("/etc/nodogsplash/nodogsplash.conf", "w")
	outfile:write(instr)
	outfile:close()
	os.execute("/etc/init.d/nodogsplash restart")
	http.redirect(luci.dispatcher.build_url('my/new/fanpage'))
end
