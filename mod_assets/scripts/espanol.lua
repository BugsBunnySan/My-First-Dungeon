language_table = {["hall_of_heroes:entry_walltext"] = "Eliga quienes se va a llevar el hado."}

function translate(text)
    local token = string.sub(text, 7, -1)
    print(token)
    local translated_text = language_table[token]    
    return translated_text
end