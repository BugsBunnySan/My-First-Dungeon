language_table = {["hall_of_heroes:entry_walltext"] = "Waehle, wen sich das Schicksal mitnehmen wird."}

function translate(text)
    local token = string.sub(text, 7, -1)
    local translated_text = language_table[token]    
    return translated_text
end