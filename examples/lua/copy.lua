infile = io.open("./nodogsplash.conf", "r")
instr = infile:read("*a")
infile:close()

-- instr = instr.gsub("/redirect_url/", "google.com")
instr = string.gsub(instr, "redirect_url", "http://google.com")

outfile = io.open("./../../etc/nodogsplash/nodogsplash.conf", "w")
outfile:write(instr)
outfile:close()