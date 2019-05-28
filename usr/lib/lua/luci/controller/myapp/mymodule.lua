module("luci.controller.myapp.mymodule", package.seeall)

function index()
    entry({"my", "new", "template"}, template("myapp-mymodule/helloworld"), "Hello world", 20).dependent=false
    entry({"my", "new", "background"}, template("myapp-mymodule/helloworld"), "Hello world", 20).dependent=false
    entry({"my", "new", "upload"}, call("uploader")).dependent=false
end

function upload_background()
	local fs = require "nixio.fs"
	local http = require "luci.http"
  local archive_tmp = "/etc/nodogsplash/htdocs/images/bg3.jpg"
  local fp
  
	http.setfilehandler(
		function(meta, chunk, eof)
			if not fp and meta and meta.name == "archive" then
				fp = io.open(archive_tmp, "wb")
			end
			if fp and chunk then
				fp:write(chunk)
			end
			if fp and eof then
				fp:close()
			end
		end
  )

  -- local f = http.formvalue("archive")[0]
  -- upload = {}
  -- if f then
  --     local name = "b3.jpg"
  --     local bytes = f
  --     local dest = io.open("/etc/nodogsplash/htdocs/images" .. "/" .. name, "wb")
  --     if dest then
  --         dest:write(bytes)
  --         dest:close()
  --     upload[1] = name
  --     end
  -- end
  http.redirect(luci.dispatcher.build_url('my/new/template'))
end

function uploader()
   local error = nil	
   --add your defaults (file_name is optional btw)
   file_loc = "/etc/nodogsplash/htdocs/images/"
   input_field = "archive"
   file_name = "b3.jpg"
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
