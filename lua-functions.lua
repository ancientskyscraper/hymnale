function isOdd(num)
    return math.mod(num, 2) ~= 0
end

function gsplit(s,sep)
    return coroutine.wrap(function()
        if s == '' or sep == '' then
            coroutine.yield(s)
            return
        end
        local lasti = 1
        for v,i in s:gmatch('(.-)'..sep..'()') do
            coroutine.yield(v)
            lasti = i
        end
        coroutine.yield(s:sub(lasti))
    end)
end
function accumulate(t,i,s,v)
    for v in i,s,v do
       t[#t+1] = v
    end
    return t
end
function tsplit(s,sep)
    return accumulate({}, gsplit(s,sep))
end

function printhymn(text)
    tex.print("\\begin{hangparas}{.25in}{1}")
    tex.print("\\footnotesize")
    tex.print("\\begin{multicols}{2}")
    local newPar = "\\par\r "
    local indentedText = text:gsub("    ", "\\hspace{1cm}")
    local splitVerses = tsplit(indentedText:gsub(string.char(10), newPar), newPar:rep(2))
    local lastVerse = ''
    if isOdd(#splitVerses) then
        lastVerse = table.remove(splitVerses):gsub(newPar, "\\\\ ")
    end
    tex.print(table.concat(splitVerses, "\\medskip\r "))
    tex.print("\\end{multicols} ")
    if (lastVerse ~= '') then
        tex.print("\\begin{center}\\begin{tabular}{l}")
        tex.print(lastVerse)
        tex.print("\\end{tabular}\\end{center}")
    end
    tex.print("\\end{hangparas} ")
end


function printheaders(occasion, author, date, translator, incipit)
    tex.print("{\\small")
    if (notEmpty(occasion) or notEmpty(author) or notEmpty(date) or notEmpty(translator)) then
        tex.print("\\begin{multicols}{2}")
        tex.print("\\noindent " .. occasion .. "\\par\n")
        tex.print("\\begin{flushright}")
        if (author ~= nil and author ~= '') then 
            tex.print(author .. ", ")
        end
        if (date ~= nil and date ~= '') then 
            tex.print(date .. " ")
        end
        if (translator ~= nil and translator ~= '') then 
            tex.print("Tr.\\ " .. translator .. "\n")
        end
        tex.print("\\end{flushright}\\end{multicols} ")
    end
    if (notEmpty(incipit)) then
        tex.print("\\centerline{\\emph{" .. incipit .. "}}")
    end
    tex.print("}")
end

function notEmpty(str)
    return (str ~= nil and str ~= '')
end